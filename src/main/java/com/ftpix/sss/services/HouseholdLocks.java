package com.ftpix.sss.services;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Serializes operations that depend on who is in a household, with a database lock held until the current transaction
 * ends.
 * <ul>
 *     <li>{@link #shared()}: creating, changing or deleting expenses and recurring expenses, which the separation of
 *     entries might be moving. Concurrent bookings don't block each other.</li>
 *     <li>{@link #exclusive()}: changing who is in a household (the separation of entries must see every booking) and
 *     changing categories (the icon check must see every category).</li>
 * </ul>
 * The lock must be taken before reading the data it protects, and before writing anything so it can't be part of a
 * deadlock.
 * <p>
 * It is a single lock for all households: which rows to lock would depend on the members, which is what it protects.
 * Exclusive operations are rare and short, so they don't need to run in parallel.
 */
@Service
public class HouseholdLocks {
    // any number, only needs to be unique among the advisory locks of the database
    private static final long LOCK_KEY = 0x535353486f757365L;

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional(propagation = Propagation.MANDATORY)
    public void shared() {
        lock("pg_advisory_xact_lock_shared");
    }

    @Transactional(propagation = Propagation.MANDATORY)
    public void exclusive() {
        lock("pg_advisory_xact_lock");
    }

    private void lock(String function) {
        // the functions return void, which can't be mapped
        entityManager.createNativeQuery("select cast(" + function + "(:key) as text)")
                .setParameter("key", LOCK_KEY)
                .getSingleResult();
    }
}
