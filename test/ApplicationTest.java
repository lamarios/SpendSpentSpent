import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static play.test.Helpers.HTMLUNIT;
import static play.test.Helpers.contentAsString;
import static play.test.Helpers.contentType;
import static play.test.Helpers.fakeApplication;
import static play.test.Helpers.inMemoryDatabase;
import static play.test.Helpers.running;
import static play.test.Helpers.testServer;

import java.util.List;

import models.Category;

import org.apache.http.conn.ssl.BrowserCompatHostnameVerifier;
import org.junit.Test;

import play.Logger;
import play.libs.F.Callback;
import play.test.TestBrowser;
import play.twirl.api.Content;

/**
 *
 * Simple (JUnit) tests that can call all parts of a play app. If you are
 * interested in mocking a whole application, see the wiki for more details.
 *
 */
public class ApplicationTest {

	@Test
	public void categoryTest() {
		running(testServer(3333, fakeApplication(inMemoryDatabase())), HTMLUNIT, new Callback<TestBrowser>() {
			public void invoke(TestBrowser browser) {
				Logger.info("Testing categories");
				List<Category> categories = Category.find.all();

				Category category = new Category();
				category.setColor("AB32DD");
				category.setId("test");
				category.setCategoryOrder(-1);

				category.save();
				assertEquals(categories.size(), Category.find.all().size());

				category.setColor("AAAAAA");
				category.setCategoryOrder(-2);
				category.save();

				Category updated = Category.find.byId(category.getId());
				assertEquals(category.getCategoryOrder(), updated.getCategoryOrder());
				assertEquals(category.getColor(), updated.getColor());

			}
		});

	}
}
