package net.sppan.base.service;


import net.sppan.base.entity.House;
import net.sppan.base.service.support.IBaseService;

public interface HouseService extends IBaseService<House, Integer> {
    /**
     * 增加或者修改
     * @param house
     */
    House saveOrUpdate(House house);

    /**
     * 查找最大id
     * @return
     */
    Integer findMaxId();
}
