package com.aliera.crm.workbench.domain;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-07 17:07
 */
public class ClueActivityRelation {
    private String id;
    private String clueId;
    private String activityId;

    public ClueActivityRelation() {
    }

    @Override
    public String toString() {
        return "ClueActivityRelation{" +
                "id='" + id + '\'' +
                ", clueId='" + clueId + '\'' +
                ", activityId='" + activityId + '\'' +
                '}';
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClueId() {
        return clueId;
    }

    public void setClueId(String clueId) {
        this.clueId = clueId;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }
}
