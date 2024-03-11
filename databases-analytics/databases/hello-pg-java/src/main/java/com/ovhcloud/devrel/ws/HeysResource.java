package com.ovhcloud.devrel.ws;

import com.ovhcloud.devrel.entity.Hey;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@Path("/heys")
public class HeysResource {
    @Inject
    EntityManager entityManager;

    @GET
    public Hey[] getHeys() {
        return entityManager.createNamedQuery("findAll", Hey.class)
                .getResultList().toArray(new Hey[0]);
    }

}
