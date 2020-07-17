package com.aliera.crm.settings.service.impl;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.settings.dao.DictionaryTypeDao;
import com.aliera.crm.settings.domain.DictionaryType;
import com.aliera.crm.settings.service.DictionaryTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @program: ProjectForCrm
 * @description: 数据字典类型服务层代理类
 * @author: Aliera
 * @create: 2020-06-29 10:50
 */

@Service
public class DictionaryTypeServiceImpl implements DictionaryTypeService {
    @Autowired
    private DictionaryTypeDao dictionaryTypeDao;

    /*
     *description: 查找所有字典类型值
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: java.util.List<com.aliera.crm.settings.domain.DictionaryType>
     */
    @Override
    public List<DictionaryType> findAllDictionaryType() {
        List<DictionaryType> dictionaryType = dictionaryTypeDao.findAllDictionaryType();
        return dictionaryType;
    }

    /*
     *description: 校验字典类型是否存在
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [code]
     *@return: boolean
     */
    @Override
    public boolean checkTypeCode(String code) {
        DictionaryType dictionaryType = dictionaryTypeDao.findDictionaryTypeByCode(code);
        if(dictionaryType != null) {
            return false;
        }
        return true;
    }

    /*
     *description: 添加字典类型
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [dictionaryType]
     *@return: void
     */
    @Override
    public void saveDictionaryType(DictionaryType dictionaryType) throws TraditionRequestException  {
        dictionaryTypeDao.saveDictionaryType(dictionaryType);
    }

    /*
     *description: 通过编码查找字典类型
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [code]
     *@return: com.aliera.crm.settings.domain.DictionaryType
     */
    @Override
    public DictionaryType findDictionaryTypeByCode(String code) {
        DictionaryType dictionaryType = dictionaryTypeDao.findDictionaryTypeByCode(code);
        return dictionaryType;
    }

    /*
     *description: 修改类型对象
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [dictionaryType]
     *@return: void
     */
    @Override
    public void updateDictionaryType(DictionaryType dictionaryType) throws TraditionRequestException {
        dictionaryTypeDao.updateDictionaryType(dictionaryType);
    }

    /*
     *description: 删除字典类型
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [codes]
     *@return: void
     */
    @Override
    public void deleteDictionaryType(String[] codes) throws TraditionRequestException {
        dictionaryTypeDao.deleteDictionaryType(codes);
    }

    /*
     *description: 查找并返回所有字典类型的编码值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: []
     *@return: java.util.List<java.lang.String>
     */
    @Override
    public List<String> findAllDictionaryTypeCode() {
        List<String> codes = dictionaryTypeDao.findAllDictionaryTypeCode();
        return codes;
    }
}
