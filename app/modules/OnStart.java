package modules;

import play.Logger;
import models.RecurringExpense;
import background.RecurringExpenseProcessor;

import com.google.inject.AbstractModule;

public class OnStart extends AbstractModule {
	
	@Override
	protected void configure() {
		Logger.info("plop");
		bind(RecurringExpenseProcessor.class).asEagerSingleton();
	}
}
