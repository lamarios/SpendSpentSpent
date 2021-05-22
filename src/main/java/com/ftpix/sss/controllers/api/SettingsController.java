package com.ftpix.sss.controllers.api;


import com.ftpix.sss.models.Settings;
import com.ftpix.sss.services.SettingsService;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/API/Settings")
@Api(tags = {"Settings"})
@PreAuthorize("hasRole('ROLE_ADMIN')")
public class SettingsController {

    private final SettingsService settingsService;

    @Autowired
    public SettingsController(SettingsService settingsService) {
        this.settingsService = settingsService;
    }

    @GetMapping
    public List<Settings> getSettings() throws SQLException {
        return settingsService.getAll();
    }

    @GetMapping("{name}")
    public Settings get(@PathVariable String name) throws SQLException {
        return settingsService.getByName(name);
    }

    @PostMapping
    public Settings save(@RequestBody Settings settings) throws SQLException {
        return settingsService.save(settings);
    }

}
