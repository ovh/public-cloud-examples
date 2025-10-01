package com.ovhcloud.sdk;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class OVHcloudSignatureHelper {
      public static String signature(String endPoint, Long timestamp) {
        // build signature
        String toSign = new StringBuilder(System.getenv("OVH_APPLICATION_SECRET"))
                .append("+")
                .append(System.getenv("OVH_CONSUMER_KEY"))
                .append("+")
                .append("GET")
                .append("+")
                .append("https://eu.api.ovh.com/v1/" + endPoint)
                .append("+")
                .append("")
                .append("+")
                .append(timestamp)
                .toString();
        try {
            return new StringBuilder("$1$").append(hashSHA1(toSign)).toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    private static String hashSHA1(String text)
            throws NoSuchAlgorithmException, UnsupportedEncodingException {
        MessageDigest md;
        md = MessageDigest.getInstance("SHA-1");
        byte[] sha1hash = new byte[40];
        md.update(text.getBytes("iso-8859-1"), 0, text.length());
        sha1hash = md.digest();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < sha1hash.length; i++) {
            sb.append(Integer.toString((sha1hash[i] & 0xff) + 0x100, 16).substring(1));
        }
        return sb.toString();
    }


}
