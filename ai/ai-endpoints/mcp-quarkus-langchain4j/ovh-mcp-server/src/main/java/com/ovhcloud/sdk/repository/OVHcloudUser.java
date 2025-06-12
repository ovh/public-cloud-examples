package com.ovhcloud.sdk.repository;

public record OVHcloudUser(String firstname, String name, String city, String country, String language) {

    public String toString() {
        return """
                First name: %s
                Last name: %s
                City: %s
                Country: %s
                Language: %s
                """.formatted(firstname, name, city, country, language);
    }
}