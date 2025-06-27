package com.ovhcloud.sdk.service;


import com.ovhcloud.sdk.repository.OVHcloudUser;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.HeaderParam;
import jakarta.ws.rs.Path;
import org.eclipse.microprofile.rest.client.annotation.ClientHeaderParam;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@Path("/v1")
@RegisterRestClient
@ClientHeaderParam(name = "X-Ovh-Consumer", value = "${ovhcloud.consumer}")
@ClientHeaderParam(name = "X-Ovh-Application", value = "${ovhcloud.application}")
@ClientHeaderParam(name = "Content-Type", value = "application/json")
public interface OVHcloudMe {

    @GET
    @Path("/me")
    OVHcloudUser getMe(@HeaderParam("X-Ovh-Signature") String signature,
                       @HeaderParam("X-Ovh-Timestamp") String ovhTimestamp);
}

