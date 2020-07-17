package com.aliera.crm.settings.dao;

import com.aliera.crm.settings.domain.DictionaryValue;

import java.util.List;
import java.util.Map;

public interface DictionaryValueDao {
    List<DictionaryValue> findAllDictionaryValue();

    DictionaryValue findDictionaryValueByValue(Map<String, String> paramsMap);

    void saveDictionaryValue(DictionaryValue dictionaryValue);

    DictionaryValue findDictionaryValueById(String id);

    void updateDictionaryValue(DictionaryValue dictionaryValue);

    void deleteDictionaryValue(String[] ids);

    List<DictionaryValue> findDictionaryValueByTypeCode(String code);
}
