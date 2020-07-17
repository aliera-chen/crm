package com.aliera.crm.settings.service.impl;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.settings.dao.DictionaryValueDao;
import com.aliera.crm.settings.domain.DictionaryValue;
import com.aliera.crm.settings.service.DictionaryValueService;
import com.aliera.crm.commons.utils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description: 服务层数据字典值代理类
 * @author: Aliera
 * @create: 2020-06-30 11:26
 */

@Service
public class DictionaryValueServiceImpl implements DictionaryValueService {
    @Autowired
    private DictionaryValueDao dictionaryValueDao;

    /*
     *description: 查找所有字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: []
     *@return: java.util.List<com.aliera.crm.settings.domain.DictionaryValue>
     */
    @Override
    public List<DictionaryValue> findAllDictionaryValue() {
        List<DictionaryValue> dicValue = dictionaryValueDao.findAllDictionaryValue();
        return dicValue;
    }

    /*
     *description: 通过字典值和字典类型查找记录
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [paramsMap]
     *@return: com.aliera.crm.settings.domain.DictionaryValue
     */
    @Override
    public DictionaryValue findDictionaryValueByValue(Map<String, String> paramsMap) {
        return dictionaryValueDao.findDictionaryValueByValue(paramsMap);
    }


    /*
     *description: 保存字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [dictionaryValue]
     *@return: void
     */
    @Override
    public void saveDictionaryValue(DictionaryValue dictionaryValue) throws TraditionRequestException {
        dictionaryValue.setId(UUIDUtil.getUUID());
        dictionaryValueDao.saveDictionaryValue(dictionaryValue);
    }

    /*
     *description: 通过id查询字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [id]
     *@return: com.aliera.crm.settings.domain.DictionaryValue
     */
    @Override
    public DictionaryValue findDictionaryValueById(String id) {
        return dictionaryValueDao.findDictionaryValueById(id);
    }

    /*
     *description: 修改字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [dictionaryValue]
     *@return: void
     */
    @Override
    public void updateDictionaryValue(DictionaryValue dictionaryValue) throws TraditionRequestException {
        dictionaryValueDao.updateDictionaryValue(dictionaryValue);
    }

    /*
     *description: 删除字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [id]
     *@return: void
     */
    @Override
    public void deleteDictionaryValue(String[] ids) throws TraditionRequestException {
        dictionaryValueDao.deleteDictionaryValue(ids);
    }

    @Override
    public List<DictionaryValue> findDictionaryValueByTypeCode(String code) {
        return dictionaryValueDao.findDictionaryValueByTypeCode(code);
    }


}
