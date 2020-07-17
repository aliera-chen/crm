package com.aliera.crm.settings.dao;

import com.aliera.crm.settings.domain.DictionaryType;

import java.util.List;

public interface DictionaryTypeDao {
    List<DictionaryType> findAllDictionaryType();

    /*
     *description: 根据编码值查找类型记录
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [code]
     *@return: com.aliera.crm.settings.domain.DictionaryType
     */
    DictionaryType findDictionaryTypeByCode(String code);

    /*
     *description: 添加字典类型
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [dictionaryType]
     *@return: void
     */
    void saveDictionaryType(DictionaryType dictionaryType);

    /*
     *description: 修改字典类型
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [dictionaryType]
     *@return: void
     */
    void updateDictionaryType(DictionaryType dictionaryType);

    /*
     *description: 删除字典类型
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [codes]
     *@return: void
     */
    void deleteDictionaryType(String[] codes);

    /*
     *description: 查找并返回所有字典类型的编码值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: []
     *@return: java.util.List<java.lang.String>
     */
    List<String> findAllDictionaryTypeCode();
}
