//package org.tfg.upm.customEngine;
//
//import org.apache.kafka.common.security.auth.SslEngineFactory;
//
//public class SslEngineDemo implements SslEngineFactory {
//
//    @Override
//    private SslEngineFactory instantiateSslEngineFactory(Map<String, Object> configs) {
//        @SuppressWarnings("unchecked")
//        Class<? extends SslEngineFactory> sslEngineFactoryClass =
//                (Class<? extends SslEngineFactory>) configs.get(SslConfigs.SSL_ENGINE_FACTORY_CLASS_CONFIG);
//        SslEngineFactory sslEngineFactory = Utils.newInstance(sslEngineFactoryClass);
//        sslEngineFactory.configure(configs);
//        this.sslEngineFactoryConfig = configs;
//        return sslEngineFactory;
//    }
//
//
//
//}
