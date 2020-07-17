package com.aliera.crm.workbench.domain;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-07 17:07
 */
public class ContactsActivityRelation {
    private String id;
    private String contactsId;
    private String activityId;

    public ContactsActivityRelation() {
    }

    public ContactsActivityRelation(ClueActivityRelation relation) {
        this.activityId = relation.getActivityId();
    }

    @Override
    public String toString() {
        return "ContactsActivityId{" +
                "id='" + id + '\'' +
                ", contactsId='" + contactsId + '\'' +
                ", activityId='" + activityId + '\'' +
                '}';
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContactsId() {
        return contactsId;
    }

    public void setContactsId(String contactsId) {
        this.contactsId = contactsId;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }


}
