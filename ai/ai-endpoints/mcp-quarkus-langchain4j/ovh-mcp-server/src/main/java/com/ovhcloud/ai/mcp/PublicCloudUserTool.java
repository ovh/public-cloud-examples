package com.ovhcloud.ai.mcp;

import com.ovhcloud.sdk.OVHcloudSignatureHelper;
import com.ovhcloud.sdk.service.OVHcloudMe;
import io.quarkiverse.mcp.server.TextContent;
import io.quarkiverse.mcp.server.Tool;
import io.quarkiverse.mcp.server.ToolResponse;
import org.eclipse.microprofile.rest.client.inject.RestClient;

public class PublicCloudUserTool {

    @RestClient
    OVHcloudMe ovhcloudMe;

    @Tool(description = "Tool to manage the OVHcloud public cloud user.")
    ToolResponse getUserDetails() {
        Long ovhTimestamp = System.currentTimeMillis() / 1000;
        return ToolResponse.success(
                new TextContent(ovhcloudMe.getMe(OVHcloudSignatureHelper.signature("me", ovhTimestamp),
                        Long.toString(ovhTimestamp)).toString()));
    }
}
