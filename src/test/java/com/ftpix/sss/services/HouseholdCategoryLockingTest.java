package com.ftpix.sss.services;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.doAnswer;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Household;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.UserRepository;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.bean.override.mockito.MockitoSpyBean;
import org.springframework.test.util.AopTestUtils;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

/**
 * Category changes racing with changes of other members or with someone joining the household. The
 * household lock must be taken before reading or writing any category, and must not depend on the
 * members it protects.
 */
@Import(TestConfig.class)
public class HouseholdCategoryLockingTest extends TestContainerTest {

  @Autowired private UserRepository userRepository;
  @Autowired private HouseholdService householdService;
  @Autowired private CategoryService categoryService;
  @Autowired private PlatformTransactionManager transactionManager;
  @MockitoSpyBean private HouseholdLocks householdLocks;

  private User partner;
  private Category house;
  private Category cloud;

  // the next exclusive lock pauses, before or after locking, until resumed
  private final AtomicBoolean pauseNextLock = new AtomicBoolean();
  private volatile boolean pauseAfterLocking;
  private final CountDownLatch paused = new CountDownLatch(1);
  private final CountDownLatch resume = new CountDownLatch(1);

  @BeforeEach
  public void setUpHousehold() throws Exception {
    partner = newUser("partner");

    Household household = householdService.createHousehold(currentUser);
    householdService.inviteUser(currentUser, partner.getEmail());
    householdService.acceptInvitation(partner, household);

    house = icon("house");
    cloud = icon("cloud");

    doAnswer(
            invocation -> {
              boolean pause = pauseNextLock.getAndSet(false);
              if (pause && !pauseAfterLocking) {
                paused.countDown();
                await(resume);
              }
              Object result = invocation.callRealMethod();
              if (pause && pauseAfterLocking) {
                paused.countDown();
                await(resume);
              }
              return result;
            })
        .when(AopTestUtils.<HouseholdLocks>getUltimateTargetObject(householdLocks))
        .exclusive();
  }

  private <T> Future<T> pausedAtLock(
      ExecutorService executor, boolean afterLocking, Callable<T> action)
      throws InterruptedException {
    pauseAfterLocking = afterLocking;
    pauseNextLock.set(true);
    Future<T> result = executor.submit(action);
    await(paused);
    return result;
  }

  private User newUser(String name) {
    User user = new User();
    user.setEmail(name + System.nanoTime() + "@test.com");
    user.setFirstName(name);
    user.setLastName("test");
    return userRepository.save(user);
  }

  private Category icon(String icon) throws Exception {
    return categoryService.getAll(currentUser).stream()
        .filter(c -> c.getIcon().equals(icon))
        .findFirst()
        .orElseThrow();
  }

  private void await(CountDownLatch latch) throws InterruptedException {
    assertTrue(latch.await(15, TimeUnit.SECONDS));
  }

  private Category edit(Category category, String icon, int order) {
    Category edit = new Category();
    edit.setId(category.getId());
    edit.setIcon(icon);
    edit.setCategoryOrder(order);
    return edit;
  }

  private List<String> icons(User user) throws Exception {
    return categoryService.getAll(user).stream().map(Category::getIcon).sorted().toList();
  }

  private long count(String icon) throws Exception {
    return icons(currentUser).stream().filter(icon::equals).count();
  }

  @Test
  public void bulkUpdateAndIconChangeDontDeadlock() throws Exception {
    ExecutorService executor = Executors.newSingleThreadExecutor();
    try {
      Future<List<Category>> bulk =
          pausedAtLock(
              executor,
              false,
              () ->
                  categoryService.updateMany(
                      List.of(
                          edit(house, "house", 42), edit(cloud, "gas", cloud.getCategoryOrder())),
                      partner));

      Category diff = new Category();
      diff.setIcon("food");
      assertTrue(categoryService.mergeCategory(house.getId(), diff, currentUser));
      resume.countDown();

      assertNotNull(bulk.get(20, TimeUnit.SECONDS));
      assertEquals(1, count("gas"));
      assertEquals(42, categoryService.get(house.getId(), currentUser).getCategoryOrder());
    } finally {
      resume.countDown();
      executor.shutdownNow();
    }
  }

  @Test
  public void bulkUpdateCannotDuplicateAnIcon() throws Exception {
    ExecutorService executor = Executors.newSingleThreadExecutor();
    try {
      Future<List<Category>> bulk =
          pausedAtLock(
              executor,
              false,
              () ->
                  categoryService.updateMany(
                      List.of(
                          edit(house, "house", house.getCategoryOrder()),
                          edit(cloud, "food", cloud.getCategoryOrder())),
                      partner));

      Category diff = new Category();
      diff.setIcon("food");
      assertTrue(categoryService.mergeCategory(house.getId(), diff, currentUser));
      resume.countDown();

      bulk.get(20, TimeUnit.SECONDS);
      assertEquals(1, count("food"));
    } finally {
      resume.countDown();
      executor.shutdownNow();
    }
  }

  @Test
  public void joiningWaitsForCategoryChangesOfTheHousehold() throws Exception {
    User owner = newUser("owner");
    User newcomer = newUser("newcomer");
    Household household = householdService.createHousehold(owner);
    Category food = categoryService.create("food", owner);
    householdService.inviteUser(owner, newcomer.getEmail());

    ExecutorService executor = Executors.newFixedThreadPool(3);
    try {
      Future<List<Category>> bulk =
          pausedAtLock(
              executor,
              true,
              () -> categoryService.updateMany(List.of(edit(food, "food", 42)), owner));

      Future<Optional<Household>> joining =
          executor.submit(() -> householdService.acceptInvitation(newcomer, household));
      assertThrows(TimeoutException.class, () -> joining.get(1, TimeUnit.SECONDS));
      Future<Category> creating = executor.submit(() -> categoryService.create("gas", newcomer));
      assertThrows(TimeoutException.class, () -> creating.get(1, TimeUnit.SECONDS));
      resume.countDown();

      assertNotNull(bulk.get(20, TimeUnit.SECONDS));
      assertTrue(joining.get(20, TimeUnit.SECONDS).isPresent());
      assertNotNull(creating.get(20, TimeUnit.SECONDS));
      assertEquals(List.of("food", "gas"), icons(owner));
    } finally {
      resume.countDown();
      executor.shutdownNow();
    }
  }

  @Test
  public void membersChangingCategoriesWhileSomeoneJoinsDontDeadlock() throws Exception {
    User owner = newUser("owner");
    User newcomer = newUser("newcomer");
    Household household = householdService.createHousehold(owner);
    householdService.inviteUser(owner, newcomer.getEmail());

    CountDownLatch joined = new CountDownLatch(1);
    CountDownLatch commitJoin = new CountDownLatch(1);
    ExecutorService executor = Executors.newFixedThreadPool(3);
    try {
      Future<Optional<Household>> joining =
          executor.submit(
              () ->
                  new TransactionTemplate(transactionManager)
                      .execute(
                          status -> {
                            try {
                              Optional<Household> result =
                                  householdService.acceptInvitation(newcomer, household);
                              joined.countDown();
                              await(commitJoin);
                              return result;
                            } catch (InterruptedException e) {
                              throw new RuntimeException(e);
                            }
                          }));
      await(joined);

      // both read the members before the join is committed
      Future<Category> ownerCreating = executor.submit(() -> categoryService.create("food", owner));
      Future<Category> newcomerCreating =
          executor.submit(() -> categoryService.create("gas", newcomer));
      assertThrows(TimeoutException.class, () -> ownerCreating.get(1, TimeUnit.SECONDS));
      assertThrows(TimeoutException.class, () -> newcomerCreating.get(1, TimeUnit.SECONDS));
      commitJoin.countDown();

      assertTrue(joining.get(20, TimeUnit.SECONDS).isPresent());
      assertNotNull(ownerCreating.get(20, TimeUnit.SECONDS));
      assertNotNull(newcomerCreating.get(20, TimeUnit.SECONDS));
      assertEquals(List.of("food", "gas"), icons(newcomer));
    } finally {
      commitJoin.countDown();
      executor.shutdownNow();
    }
  }
}
