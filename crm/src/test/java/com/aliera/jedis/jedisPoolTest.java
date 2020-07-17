package com.aliera.jedis;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-16 16:29
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/applicationContext.xml"})
public class jedisPoolTest {

    @Autowired
    JedisPool jedisPool;

    @Test
    public void test() {
        System.out.println(jedisPool);
        Jedis jedis = jedisPool.getResource();
        System.out.println(jedis.smembers("job"));
    }
}
