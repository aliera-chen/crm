package com.aliera.crm.commons.constant;

/**
 * @program: ProjectForCrm
 * @description: 市场活动常量
 * @author: Aliera
 * @create: 2020-07-03 16:38
 */
public class ActivityConstant {
    //市场活动导出常量
    public static class ExportActivity {

        //总变量数
        public static final int VAL_COUNT = 11;

        //变量编号
        public static final int ID_NO = 0;
        public static final int OWNER_NO = 1;
        public static final int NAME_NO = 2;
        public static final int STARTDATE_NO = 3;
        public static final int ENDDATE_NO = 4;
        public static final int COST_NO = 5;
        public static final int DESCRIPTION_NO = 6;
        public static final int CREATETIME_NO = 7;
        public static final int CREATEBY_NO = 8;
        public static final int EDITTIME_NO = 9;
        public static final int EDITBY_NO = 10;
    }

    //市场活动导入常量
    public static class ImportActivity {
        //总变量数
        public static final int VAL_COUNT = 5;

        public static final int NAME_NO = 0;
        public static final int STARTDATE_NO = 1;
        public static final int ENDDATE_NO = 2;
        public static final int COST_NO = 3;
        public static final int DESCRIPTION_NO = 4;
    }

}
