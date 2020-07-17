package com.aliera.crm.workbench.domain;

/**
 * @program: ProjectForCrm
 * @description: 联系人实体类
 * @author: Aliera
 * @create: 2020-07-07 12:29
 */
public class Contacts {

    private String id;
    private String owner;
    private String source;
    private String customerId;
    private String fullname;
    private String appellation;
    private String email;
    private String mphone;
    private String job;
    private String birth;
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String description;
    private String contactSummary;
    private String nextContactTime;
    private String address;

    public Contacts() {
    }

    /*
     *description: 使用线索和客户生成联系人
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [clue]
     *@return:
     */
    public Contacts(Clue clue) {
        this.owner = clue.getOwner();
        this.source = clue.getSource();
        this.fullname = clue.getFullname();
        this.appellation = clue.getAppellation();
        this.email = clue.getEmail();
        this.mphone = clue.getMphone();
        this.job = clue.getJob();
        this.description = clue.getDescription();
        this.contactSummary = clue.getContactSummary();
        this.nextContactTime = clue.getNextContactTime();
        this.address = clue.getAddress();
    }

    @Override
    public String toString() {
        return "Contacts{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", source='" + source + '\'' +
                ", customerId='" + customerId + '\'' +
                ", fullname='" + fullname + '\'' +
                ", appellation='" + appellation + '\'' +
                ", email='" + email + '\'' +
                ", mphone='" + mphone + '\'' +
                ", job='" + job + '\'' +
                ", birth='" + birth + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", description='" + description + '\'' +
                ", contactSummary='" + contactSummary + '\'' +
                ", nextContactTime='" + nextContactTime + '\'' +
                ", address='" + address + '\'' +
                '}';
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getAppellation() {
        return appellation;
    }

    public void setAppellation(String appellation) {
        this.appellation = appellation;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMphone() {
        return mphone;
    }

    public void setMphone(String mphone) {
        this.mphone = mphone;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getBirth() {
        return birth;
    }

    public void setBirth(String birth) {
        this.birth = birth;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContactSummary() {
        return contactSummary;
    }

    public void setContactSummary(String contactSummary) {
        this.contactSummary = contactSummary;
    }

    public String getNextContactTime() {
        return nextContactTime;
    }

    public void setNextContactTime(String nextContactTime) {
        this.nextContactTime = nextContactTime;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
