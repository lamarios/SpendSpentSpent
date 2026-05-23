package com.ftpix.sss.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ftpix.sss.persistence.utils.BooleanToIntConverter;
import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "\"user\"")
public class User {
    public final static long NEVER = Long.MAX_VALUE - 1;

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @JdbcTypeCode(SqlTypes.VARCHAR)
    private UUID id;


    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Category> categories;

    private String email;

    @Column(name = "firstname")
    private String firstName;
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @JsonIgnore
    @Column(name = "password_bcrypt")
    private String passwordBcrypt;

    @Column(name = "lastname")
    private String lastName;

    @Column(name = "subscriptionexpirydate")
    @JsonIgnore
    private long subscriptionExpiryDate;

    @Column(name = "showannouncement")
    @Convert(converter = BooleanToIntConverter.class)
    private boolean showAnnouncement = false;

    @JsonProperty("isAdmin")
    @Column(name = "isadmin")
    @Convert(converter = BooleanToIntConverter.class)
    private boolean isAdmin = false;

    @JsonIgnore
    @Column(name = "oidcsub")
    private String oidcSub;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public long getSubscriptionExpiryDate() {
        return subscriptionExpiryDate;
    }

    public void setSubscriptionExpiryDate(long subscriptionExpiryDate) {
        this.subscriptionExpiryDate = subscriptionExpiryDate;
    }

    public boolean isShowAnnouncement() {
        return showAnnouncement;
    }

    public void setShowAnnouncement(boolean showAnnouncement) {
        this.showAnnouncement = showAnnouncement;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getOidcSub() {
        return oidcSub;
    }

    public void setOidcSub(String oidcSub) {
        this.oidcSub = oidcSub;
    }

    public String getPasswordBcrypt() {
        return passwordBcrypt;
    }

    public void setPasswordBcrypt(String passwordBcrypt) {
        this.passwordBcrypt = passwordBcrypt;
    }


    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }
}
