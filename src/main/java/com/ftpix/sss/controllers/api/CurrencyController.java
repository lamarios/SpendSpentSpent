package com.ftpix.sss.controllers.api;

import com.ftpix.sss.services.CurrencyService;
import com.ftpix.sss.services.SettingsService;
import com.mashape.unirest.http.exceptions.UnirestException;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;

@RestController
@RequestMapping("/API/Currency")
@Api(tags = {"Currency"})
public class CurrencyController {


    private final CurrencyService currencyService;

    @Autowired
    public CurrencyController(CurrencyService currencyService) {
        this.currencyService = currencyService;
    }


    @GetMapping("{from}/{to}")
    public Double get(@PathVariable String from, @PathVariable String to) throws SQLException, UnirestException {
        return currencyService.getCurrency(from, to);
    }
}
