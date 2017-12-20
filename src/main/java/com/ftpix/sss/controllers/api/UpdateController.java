package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkGet;
import com.ftpix.sss.Constants;
import com.ftpix.sss.models.UpdateInfo;
import com.ftpix.sss.transformer.GsonTransformer;
import com.ftpix.sss.utils.StreamGobbler;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.kohsuke.github.GHAsset;
import org.kohsuke.github.GHRelease;
import org.kohsuke.github.GitHub;
import org.pegdown.ast.CodeNode;
import pl.touk.throwing.ThrowingConsumer;
import pl.touk.throwing.ThrowingFunction;
import pl.touk.throwing.exception.WrappedException;
import spark.template.jade.JadeTemplateEngine;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

@SparkController("/API/Updater")
public class UpdateController {
    private final static Logger logger = LogManager.getLogger();

    private static final String CAN_AUTO_UPDATE = "1";
    private final static String BETA = "B", RELEASE_CANDIDATE = "RC";
    private static final String SPEND_SPENT_SPENT_JAR = "SpendSpentSpent-?(\\d*)(-(RC|B)\\d+)?\\.jar";
    private static final String SPEND_SPENT_SPENT_JAR_IN_FILE_SYSTEM = "(.*)" + SPEND_SPENT_SPENT_JAR + "$";
    private static final String JAVA_OPTS_SEPARATER = "___";

    /**
     * Let the user know if he/she is using the latest version of SSS based on github releases
     *
     * @return the info to let the user update is possible
     */
    @SparkGet(transformer = GsonTransformer.class)
    public UpdateInfo getUpdateInfo() throws IOException {
        UpdateInfo updateInfo = new UpdateInfo();
        updateInfo.setCurrentVersion(getClass().getPackage().getImplementationVersion());

        getLatestRelease()
                .map(GHRelease::getName)
                .ifPresent(updateInfo::setLatestVersion);


        String canAutoUpdate = canAutoUpdate(updateInfo.getCurrentVersion(), updateInfo.getLatestVersion());
        updateInfo.setCanAutoUpdate(canAutoUpdate.equalsIgnoreCase(CAN_AUTO_UPDATE));
        updateInfo.setMessage(canAutoUpdate);


        return updateInfo;
    }


    @SparkGet("/do-update")
    public boolean doUpdate() throws IOException {
        try {
            logger.info("Getting last release");
            List<GHAsset> releases = getLatestRelease()
                    .map(ThrowingFunction.unchecked(GHRelease::getAssets))
                    .orElse(Collections.emptyList());

            logger.info("found {} releases", releases.size());

            releases.stream()
                    .filter(a -> a.getName().matches(SPEND_SPENT_SPENT_JAR))
                    .findFirst()
                    .ifPresent(ThrowingConsumer.unchecked(r -> {
                        URL website = new URL(r.getBrowserDownloadUrl());
                        String tempFile = Files.createTempFile("SSS-", "").toAbsolutePath().toString() + ".jar";
                        logger.info("Downloading release {} from {} to file {}", r.getName(), r.getBrowserDownloadUrl(), tempFile);
//            URL website = new URL("file:///home/gz/IdeaProjects/SpendSpentSpent/target/SpendSpentSpent-2-B5.jar");

                        try (
                                ReadableByteChannel rbc = Channels.newChannel(website.openStream());
                                FileOutputStream fos = new FileOutputStream(tempFile);
                        ) {
                            fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);

                        }


                        runUpgradeScript(tempFile);
                    }));

            return true;
        } catch (WrappedException e) {
            logger.error("Couldn't do update", e);
            return false;
        }
    }


    /**
     * Will run the upgrade script
     */
    private void runUpgradeScript(String pathToNewJar) throws IOException {
        try {
            Files.list(Paths.get("." + (Constants.DEV_MODE ? "/target" : "")))
                    .peek(System.out::println)
                    .filter(p -> p.toString().matches(SPEND_SPENT_SPENT_JAR_IN_FILE_SYSTEM))
                    .map(p -> p.toAbsolutePath())
                    .findFirst().ifPresent(ThrowingConsumer.unchecked(pathToOldJar -> {

                        StringBuilder builder = new StringBuilder();
                        builder.append("-D").append(Constants.CFG_DB_URL).append("=").append(Constants.DB_PATH).append(JAVA_OPTS_SEPARATER);
                        builder.append("-D").append(Constants.CFG_PORT).append("=").append(Constants.HTTP_PORT).append(JAVA_OPTS_SEPARATER);
                        builder.append("-D").append(Constants.CFG_SALT).append("=").append(Constants.SALT).append(JAVA_OPTS_SEPARATER);


                        ProcessBuilder processBuilder = new ProcessBuilder();
                        processBuilder.command("java", "-jar", pathToOldJar.toString(), "update", pathToOldJar.toString(), pathToNewJar, builder.toString());
                        processBuilder.directory(pathToOldJar.getParent().toFile());

                        logger.info("Running command: {}", processBuilder.command().stream().collect(Collectors.joining(" ")));

                        Process process = processBuilder.start();

                        logger.info("Going dark before update  script /pray");
                        System.exit(0);
//                        int exitCode = process.waitFor();
                    })
            );
        } catch (WrappedException e) {
            logger.error("Couldn't execute update script", e);
        }
    }

    /**
     * Does the actual update
     *
     * @param params there should have 4 params here, 0 = "update", 1 = path to old jar, 2 = path to updated jar, 3 = java opts
     */
    public void deployUpdate(String... params) throws IOException {
        Path oldJar = Paths.get(params[1]);
        Path newJar = Paths.get(params[2]);
        Path installParentFolder = oldJar.getParent();
        Path updatedJar = installParentFolder.resolve("SpendSpentSpent.jar");
        String javaOpts = params[3];

        logger.info("Updating Spend Spent Spent oldjar:[{}], newJar :[{}], installParentFolder:[{}], updatedJar:[{}]", oldJar, newJar, installParentFolder, updatedJar);

        if (Files.exists(oldJar) && Files.exists(newJar)) {
            Files.move(oldJar, installParentFolder.resolve("SpendSpentSpent.jar.bak"));
            Files.move(newJar, installParentFolder.resolve("SpendSpentSpent.jar"));

            List<String> command = new ArrayList<>();
            command.add("java");
            command.addAll(Arrays.asList(javaOpts.split(JAVA_OPTS_SEPARATER)));
            command.add("-jar");
            command.add(updatedJar.toString());


            logger.info("Executing command:");
            logger.info(command.stream().collect(Collectors.joining(" ")));
            ProcessBuilder pb = new ProcessBuilder(command.toArray(new String[command.size()]));
            pb.directory(installParentFolder.toFile());
            pb.start();
            System.exit(0);

        } else {
            logger.info("New and old jar don't exist");
            System.exit(1);
        }


    }


    /**
     * Will extract the update shell script from the resource folder
     *
     * @return the path of the script
     */
    private String writeUpdateScriptToDisk() throws IOException {
        Path script = Files.createTempFile("SSS-updater", ".sh").toAbsolutePath();

        try (
                InputStream inputStream = getClass().getResource("/scripts/updateScript.sh").openStream();
        ) {
            logger.info("Writing update script to {}", script);
            Files.copy(inputStream, script, StandardCopyOption.REPLACE_EXISTING);
        }

        script.toFile().setExecutable(true);

        return script.toString();
    }

    /**
     * Checks if the current installation allows auto update
     *
     * @return "1" if auto update is possible, an error message if not
     */
    private String canAutoUpdate(String currentVersion, String latestVersion) throws IOException {

        Path workingDir = Paths.get("." + (Constants.DEV_MODE ? "/target" : ""));


        if (!Files.isWritable(workingDir)) {
            return "Current folder is not writable";
        }

        if (Files.list(workingDir)
                .noneMatch(p -> p.toString().matches(SPEND_SPENT_SPENT_JAR_IN_FILE_SYSTEM))
                ) {
            return "Can't find SpendSpentSpent jar file in current working dir";
        }


        if (compareVersion(currentVersion, latestVersion) > -1) {
            return "Current version is either same or newer than latest available on github";
        }

        return CAN_AUTO_UPDATE;
    }

    /**
     * Will return the latest release available on github
     *
     * @return the github release
     * @throws IOException
     */
    private Optional<GHRelease> getLatestRelease() throws IOException {
        GitHub gitHub = GitHub.connectAnonymously();
        return gitHub.getRepository("lamarios/SpendSpentSpent").listReleases().asList().stream()
                .findFirst();
    }

    /**
     * Compare two different versions
     *
     * @param currentVersion the current version
     * @param latestVersion  the latest version from github
     * @return -1 if current is before latest, 0 if it's the same, 1 if latest if before current
     */
    public int compareVersion(String currentVersion, String latestVersion) {
        if (currentVersion == null || currentVersion.length() == 0 || latestVersion == null || latestVersion.length() == 0) {
            return 0;
        }
        String[] currentSplit = currentVersion.split("-");
        String[] latestSplit = latestVersion.split("-");


        //if same no need to think too much
        if (currentVersion.equalsIgnoreCase(latestVersion)) {
            return 0;
        }

        try {
            int digitCompare = Integer.compare(Integer.parseInt(currentSplit[0]), Integer.parseInt(latestSplit[0]));

            if (digitCompare == 0) {
                //if same we need to compare the second part of the version
                if (currentSplit.length == 2 && latestSplit.length == 1) {
                    //current version is either RC or BETA and latest is normal version
                    return -1;
                }


                if (currentSplit.length == 1 && latestSplit.length == 2) {
                    // latest version is somewhate earlier than current
                    return 1;
                }


                //comparing the version specifics
                if (currentSplit[1].replaceAll("\\d+", "").equalsIgnoreCase(latestSplit[1].replaceAll("\\d+", ""))) {
                    //if we have both BETA or RC
                    int currentSpecificVersion = Integer.parseInt(currentSplit[1].replaceAll("\\D+", ""));
                    int latestSpecificVersion = Integer.parseInt(latestSplit[1].replaceAll("\\D+", ""));

                    return Integer.compare(currentSpecificVersion, latestSpecificVersion);

                } else {
                    //we have one beta and one RC
                    if (currentSplit[1].startsWith(BETA)) {
                        //if both different, is current is beta, latest is definitely RC
                        return -1;
                    } else {
                        return 1;
                    }
                }
            } else {
                return digitCompare;
            }


        } catch (NumberFormatException e) {
            //Can't compare version numbers that don't make sense
            return 0;
        }
    }
}
