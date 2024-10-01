package com.ovhcloud.examples.aiendpoints.nlp.sentiment;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

public class EmotionEvaluation {
    private Double admiration;
    private Double amusement;
    private Double anger;
    private Double annoyance;
    private Double approval;
    private Double caring;
    private Double confusion;
    private Double curiosity;
    private Double desire;
    private Double disappointment;
    private Double disapproval;
    private Double disgust;
    private Double embarrassment;
    private Double excitement;
    private Double fear;
    private Double gratitude;
    private Double grief;
    private Double joy;
    private Double love;
    private Double nervousness;
    private Double neutral;
    private Double optimism;
    private Double pride;
    private Double realization;
    private Double relief;
    private Double remorse;
    private Double sadness;
    private Double surprise;

    // Utilities method

    private SortedMap<String, Double> toSortedMap(EmotionEvaluation emotion) {
        Map<String, Double> map = toMap(emotion);

        Comparator<String> valueComparator = new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                return map.get(o2).compareTo(map.get(o1)); // reversed for descending order
            }
        };

        SortedMap<String, Double> sortedMap = new TreeMap<>(valueComparator);
        sortedMap.putAll(map);
        return sortedMap;
    }

    public String toEmoji() {
        String firstEmotion = toSortedMap(this).firstKey();
        // Transform an emotion name into a corresponding emoji
        switch (firstEmotion) {
            case "admiration":
                return "🥹";
            case "amusement":
                return "😆";
            case "anger":
                return "😡";
            case "annoyance":
                return "🙄";
            case "approval":
                return "👍";
            case "caring":
                return "🤷‍♂️";
            case "confusion":
                return "🤔";
            case "curiosity":
                return "🤩";
            case "desire":
                return "🥰";
            case "disappointment":
                return "😞";
            case "disapproval":
                return "😤";
            case "disgust":
                return "🤮";
            case "embarrassment":
                return "😰";
            case "excitement":
                return "🥳";
            case "fear":
                return "😱";
            case "gratitude":
                return "🙏";
            case "grief":
                return "😢";
            case "joy":
                return "😁";
            case "love":
                return "😍";
            case "nervousness":
                return "😨";
            case "neutral":
                return "😐";
            case "optimism":
                return "🤗";
            case "pride":
                return "😎";
            case "realization":
                return "🙂‍↔️";
            case "relief":
                return "🫣";
            case "remorse":
                return "😖";
            case "sadness":
                return "😭";
            case "surprise":
                return "😮";
            default:
                return "⁉️";
        }
    }

    private Map<String, Double> toMap(EmotionEvaluation emotion) {
        Map<String, Double> map = new HashMap<>();
        map.put("admiration", emotion.getAdmiration());
        map.put("amusement", emotion.getAmusement());
        map.put("anger", emotion.getAnger());
        map.put("annoyance", emotion.getAnnoyance());
        map.put("approval", emotion.getApproval());
        map.put("caring", emotion.getCaring());
        map.put("confusion", emotion.getConfusion());
        map.put("curiosity", emotion.getCuriosity());
        map.put("desire", emotion.getDesire());
        map.put("disappointment", emotion.getDisappointment());
        map.put("disapproval", emotion.getDisapproval());
        map.put("disgust", emotion.getDisgust());
        map.put("embarrassment", emotion.getEmbarrassment());
        map.put("excitement", emotion.getExcitement());
        map.put("fear", emotion.getFear());
        map.put("gratitude", emotion.getGratitude());
        map.put("grief", emotion.getGrief());
        map.put("joy", emotion.getJoy());
        map.put("love", emotion.getLove());
        map.put("nervousness", emotion.getNervousness());
        map.put("optimism", emotion.getOptimism());
        map.put("pride", emotion.getPride());
        map.put("realization", emotion.getRealization());
        map.put("relief", emotion.getRelief());
        map.put("remorse", emotion.getRemorse());
        map.put("sadness", emotion.getSadness());
        map.put("surprise", emotion.getSurprise());
        return map;
    }

    // Getters & Setters
    public Double getAdmiration() {
        return admiration;
    }

    public void setAdmiration(Double admiration) {
        this.admiration = admiration;
    }

    public Double getAmusement() {
        return amusement;
    }

    public void setAmusement(Double amusement) {
        this.amusement = amusement;
    }

    public Double getAnger() {
        return anger;
    }

    public void setAnger(Double anger) {
        this.anger = anger;
    }

    public Double getAnnoyance() {
        return annoyance;
    }

    public void setAnnoyance(Double annoyance) {
        this.annoyance = annoyance;
    }

    public Double getApproval() {
        return approval;
    }

    public void setApproval(Double approval) {
        this.approval = approval;
    }

    public Double getCaring() {
        return caring;
    }

    public void setCaring(Double caring) {
        this.caring = caring;
    }

    public Double getConfusion() {
        return confusion;
    }

    public void setConfusion(Double confusion) {
        this.confusion = confusion;
    }

    public Double getCuriosity() {
        return curiosity;
    }

    public void setCuriosity(Double curiosity) {
        this.curiosity = curiosity;
    }

    public Double getDesire() {
        return desire;
    }

    public void setDesire(Double desire) {
        this.desire = desire;
    }

    public Double getDisappointment() {
        return disappointment;
    }

    public void setDisappointment(Double disappointment) {
        this.disappointment = disappointment;
    }

    public Double getDisapproval() {
        return disapproval;
    }

    public void setDisapproval(Double disapproval) {
        this.disapproval = disapproval;
    }

    public Double getDisgust() {
        return disgust;
    }

    public void setDisgust(Double disgust) {
        this.disgust = disgust;
    }

    public Double getEmbarrassment() {
        return embarrassment;
    }

    public void setEmbarrassment(Double embarrassment) {
        this.embarrassment = embarrassment;
    }

    public Double getExcitement() {
        return excitement;
    }

    public void setExcitement(Double excitement) {
        this.excitement = excitement;
    }

    public Double getFear() {
        return fear;
    }

    public void setFear(Double fear) {
        this.fear = fear;
    }

    public Double getGratitude() {
        return gratitude;
    }

    public void setGratitude(Double gratitude) {
        this.gratitude = gratitude;
    }

    public Double getGrief() {
        return grief;
    }

    public void setGrief(Double grief) {
        this.grief = grief;
    }

    public Double getJoy() {
        return joy;
    }

    public void setJoy(Double joy) {
        this.joy = joy;
    }

    public Double getLove() {
        return love;
    }

    public void setLove(Double love) {
        this.love = love;
    }

    public Double getNervousness() {
        return nervousness;
    }

    public void setNervousness(Double nervousness) {
        this.nervousness = nervousness;
    }

    public Double getNeutral() {
        return neutral;
    }

    public void setNeutral(Double neutral) {
        this.neutral = neutral;
    }

    public Double getOptimism() {
        return optimism;
    }

    public void setOptimism(Double optimism) {
        this.optimism = optimism;
    }

    public Double getPride() {
        return pride;
    }

    public void setPride(Double pride) {
        this.pride = pride;
    }

    public Double getRealization() {
        return realization;
    }

    public void setRealization(Double realization) {
        this.realization = realization;
    }

    public Double getRelief() {
        return relief;
    }

    public void setRelief(Double relief) {
        this.relief = relief;
    }

    public Double getRemorse() {
        return remorse;
    }

    public void setRemorse(Double remorse) {
        this.remorse = remorse;
    }

    public Double getSadness() {
        return sadness;
    }

    public void setSadness(Double sadness) {
        this.sadness = sadness;
    }

    public Double getSurprise() {
        return surprise;
    }

    public void setSurprise(Double surprise) {
        this.surprise = surprise;
    }

    @Override
    public String toString() {
        return "EmotionEvaluation [admiration=" + admiration + ", amusement=" + amusement + ", anger="
                + anger + ", annoyance=" + annoyance + ", approval=" + approval + ", caring=" + caring
                + ", confusion=" + confusion + ", curiosity=" + curiosity + ", desire=" + desire
                + ", disappointment=" + disappointment + ", disapproval=" + disapproval + ", disgust="
                + disgust + ", embarrassment=" + embarrassment + ", excitement=" + excitement + ", fear="
                + fear + ", gratitude=" + gratitude + ", grief=" + grief + ", joy=" + joy + ", love=" + love
                + ", nervousness=" + nervousness + ", neutral=" + neutral + ", optimism=" + optimism
                + ", pride=" + pride + ", realization=" + realization + ", relief=" + relief + ", remorse="
                + remorse + ", sadness=" + sadness + ", surprise=" + surprise + ", getAdmiration()="
                + getAdmiration() + ", getAmusement()=" + getAmusement() + ", getAnger()=" + getAnger()
                + ", getAnnoyance()=" + getAnnoyance() + ", getApproval()=" + getApproval()
                + ", getClass()=" + getClass() + ", getCaring()=" + getCaring() + ", getConfusion()="
                + getConfusion() + ", getCuriosity()=" + getCuriosity() + ", getDesire()=" + getDesire()
                + ", getDisappointment()=" + getDisappointment() + ", getDisapproval()=" + getDisapproval()
                + ", getDisgust()=" + getDisgust() + ", getEmbarrassment()=" + getEmbarrassment()
                + ", getExcitement()=" + getExcitement() + ", getFear()=" + getFear() + ", getGratitude()="
                + getGratitude() + ", getGrief()=" + getGrief() + ", getJoy()=" + getJoy() + ", getLove()="
                + getLove() + ", hashCode()=" + hashCode() + ", getNervousness()=" + getNervousness()
                + ", getNeutral()=" + getNeutral() + ", getOptimism()=" + getOptimism() + ", getPride()="
                + getPride() + ", getRealization()=" + getRealization() + ", getRelief()=" + getRelief()
                + ", getRemorse()=" + getRemorse() + ", getSadness()=" + getSadness() + ", getSurprise()="
                + getSurprise() + ", toString()=" + super.toString() + "]";
    }


}
