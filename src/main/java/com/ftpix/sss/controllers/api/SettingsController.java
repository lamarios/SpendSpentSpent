package com.ftpix.sss.controllers.api;


import com.ftpix.sss.models.Settings;
import com.ftpix.sss.services.CurrencyService;
import com.ftpix.sss.services.SettingsService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/API/Settings")
@Tag(name = "Settings")
@PreAuthorize("hasRole('ROLE_ADMIN')")
@SecurityRequirement(name = "bearerAuth")
public class SettingsController {

    private final SettingsService settingsService;
    private final CurrencyService currencyService;

    @Autowired
    public SettingsController(SettingsService settingsService, CurrencyService currencyService) {
        this.settingsService = settingsService;
        this.currencyService = currencyService;
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
        Settings save = settingsService.save(settings);
        if(save.getName().equalsIgnoreCase(Settings.CURRENCY_API_KEY)){
           currencyService.resetCache();
        }
        return save;
    }

}
