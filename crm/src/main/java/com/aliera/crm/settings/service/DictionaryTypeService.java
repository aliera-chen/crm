package com.aliera.crm.settings.service;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.settings.domain.DictionaryType;

import java.util.List;

public interface DictionaryTypeService {
    /*
     *description: 查找并返回数据字典类型列表
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: java.util.List<com.aliera.crm.settings.domain.DictionaryType>
     */
    List<DictionaryType> findAllDictionaryType();

    /*
     *description: 查找并返回编码值是否可用，是代表可用，否代表已存在
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [code]
     *@return: boolean
     */
    boolean checkTypeCode(String code);

    /*
     *description: 保存字典类型
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [dictionaryType]
     *@return: void
     */
    void saveDictionaryType(DictionaryType dictionaryType) throws TraditionRequestException;

    /*
     *description: 通过编码值查找类型对象
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [code]
     *@return: com.aliera.crm.settings.domain.DictionaryType
     */
    DictionaryType findDictionaryTypeByCode(String code);

    /*
     *description: 修改字典类型
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [dictionaryType]
     *@return: void
     */
    void updateDictionaryType(DictionaryType dictionaryType) throws TraditionRequestException;

    /*
     *description: 删除字典类型
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [codes]
     *@return: void
     */
    void deleteDictionaryType(String[] codes) throws TraditionRequestException;

    /*
     *description: 查找并返回所有字典类型的编码值，用于新增字典值功能的下拉菜单
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: []
     *@return: java.util.List<java.lang.String>
     */
    List<String> findAllDictionaryTypeCode();
}
