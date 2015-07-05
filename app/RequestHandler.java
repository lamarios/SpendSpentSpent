import play.Logger;
import play.http.HttpRequestHandler;
import play.libs.F;
import play.libs.F.Function0;
import play.libs.F.Promise;
import play.mvc.Action;
import play.mvc.Http;
import play.mvc.Result;
import play.mvc.Http.Context;
import play.mvc.Http.Cookie;
import play.mvc.Http.Request;

import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

import models.Setting;
import models.UserSession;

public class RequestHandler implements HttpRequestHandler {
	private final String TOKEN = "Authorization";

	@Override
	public Action createAction(final Request request, Method actionMethod) {
		Logger.info("before each request..." + request.toString() + " Method:" + actionMethod.getModifiers());
		// Request req

		if (request.path().startsWith("/API") && Setting.get(Setting.AUTHENTICATION).equalsIgnoreCase("true") && !Setting.get(Setting.USERNAME).equalsIgnoreCase("") && !Setting.get(Setting.PASSWORD).equalsIgnoreCase("")) {
			Action auth = apiRequestHandle(request);

			if (auth != null) {
				return auth;
			}

		}

		return new Action.Simple() {
			@Override
			public F.Promise<Result> call(Http.Context ctx) throws Throwable {
				return delegate.call(ctx);
			}
		};
	}

	private Action apiRequestHandle(final Request request) {
		// TODO Auto-generated method stub
		Action unauthorized = new Action.Simple() {

			@Override
			public Promise<Result> call(Context arg0) throws Throwable {

				Promise<Result> promise = Promise.promise(new Function0<Result>() {
					public Result apply() {
						return unauthorized("No API Key");
					}
				});

				return promise;
			}
		};

		Map<String, String[]> headers = request.headers();
		if (headers != null) {
			if (!headers.containsKey(TOKEN)) {
				Logger.info("No API key in parameters");
				return unauthorized;
			}

			String token = headers.get(TOKEN)[0];
			UserSession session = UserSession.find.byId(token);

			Calendar today = new GregorianCalendar();

			if (session == null || today.after(session.getExpiryDate())) {
				Logger.info("Api key not matching");
				return unauthorized;
			}
		} else {
			Logger.info("POST null");
			return unauthorized;
		}

		return null;
	}

	@Override
	public Action wrapAction(Action action) {
		// TODO Auto-generated method stub
		return action;
	}
}
