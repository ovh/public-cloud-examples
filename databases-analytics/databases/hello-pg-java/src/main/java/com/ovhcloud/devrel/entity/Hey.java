package com.ovhcloud.devrel.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;

@Entity
@NamedQueries({
    @NamedQuery(name="findAll", query="SELECT h FROM Hey h")
})
public class Hey {
    @Id
    @GeneratedValue
    public Long id;

    public String name;
}
