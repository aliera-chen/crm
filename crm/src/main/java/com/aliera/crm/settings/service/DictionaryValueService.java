package com.aliera.crm.settings.service;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.settings.domain.DictionaryType;
import com.aliera.crm.settings.domain.DictionaryValue;

import java.util.List;
import java.util.Map;

public interface DictionaryValueService {
    List<DictionaryValue> findAllDictionaryValue();

    /*
     *description: 通过类型名和字典值查找字典值，当没有同名值时返回true，已有记录时返回false
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [paramsMap]
     *@return: boolean
     */
    DictionaryValue findDictionaryValueByValue(Map<String, String> paramsMap);

    void saveDictionaryValue(DictionaryValue dictionaryValue) throws TraditionRequestException;

    /*
     *description: 通过id查询字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [id]
     *@return: com.aliera.crm.settings.domain.DictionaryValue
     */
    DictionaryValue findDictionaryValueById(String id);

    void updateDictionaryValue(DictionaryValue dictionaryValue) throws TraditionRequestException;

    void deleteDictionaryValue(String[] ids) throws TraditionRequestException;

    List<DictionaryValue> findDictionaryValueByTypeCode(String code);
}
