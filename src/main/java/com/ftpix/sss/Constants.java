package com.ftpix.sss;

import java.time.format.DateTimeFormatter;
import java.util.Optional;

public class Constants {

  public static final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
  public static final DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
  public static final String TIMEZONE_HEADER = "x-timezone";

  public static final String JSON = "application/json";
  public static final boolean ALLOW_SIGNUP =
      Optional.ofNullable(System.getenv("ALLOW_SIGNUP"))
          .map(s -> s.equalsIgnoreCase("1"))
          .orElse(false);

  public static final Optional<String> ANNOUNCEMENT_MESSAGE =
      Optional.ofNullable(System.getenv("ANNOUNCEMENT_MESSAGE"));

  public static final boolean HAS_SUBSCRIPTIONS =
      Optional.ofNullable(System.getenv("HAS_SUBSCRIPTION"))
          .map(s -> s.equalsIgnoreCase("1"))
          .orElse(false);

  public static final boolean ALLOW_IMPORT =
      Optional.ofNullable(System.getenv("ALLOW_IMPORT"))
          .map(s -> s.equalsIgnoreCase("1"))
          .orElse(false);

  static {
    System.out.println("SpendSpentSpent config ====================");
    System.out.println("ALLOW_SIGNUP = " + ALLOW_SIGNUP);
    System.out.println("ALLOW_IMPORT = " + ALLOW_IMPORT);
  }
}
