package com.aliera.crm.workbench.domain;

/**
 * @program: ProjectForCrm
 * @description: 联系人备注
 * @author: Aliera
 * @create: 2020-07-07 12:31
 */
public class ContactsRemark {

    private String id;
    private String noteContent;
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String editFlag;
    private String contactsId;

    public ContactsRemark() {
    }

    public ContactsRemark(ClueRemark clueRemark) {
        this.noteContent = clueRemark.getNoteContent();
        this.createBy = clueRemark.getCreateBy();
        this.createTime = clueRemark.getCreateTime();
        this.editBy = clueRemark.getEditBy();
        this.editTime = clueRemark.getEditTime();
        this.editFlag = clueRemark.getEditFlag();
    }

    @Override
    public String toString() {
        return "ContactsRemark{" +
                "id='" + id + '\'' +
                ", noteContent='" + noteContent + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editFlag='" + editFlag + '\'' +
                ", contactsId='" + contactsId + '\'' +
                '}';
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNoteContent() {
        return noteContent;
    }

    public void setNoteContent(String noteContent) {
        this.noteContent = noteContent;
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

    public String getEditFlag() {
        return editFlag;
    }

    public void setEditFlag(String editFlag) {
        this.editFlag = editFlag;
    }

    public String getContactsId() {
        return contactsId;
    }

    public void setContactsId(String contactsId) {
        this.contactsId = contactsId;
    }
}
