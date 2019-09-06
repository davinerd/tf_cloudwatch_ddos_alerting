locals {
    alb_thresholds = {
        RequestCount = 200,
        ActiveConnectionCount = 100,
        HTTPCode_ELB_4XX_Count = 100,
        TargetResponseTime = 11,
        HTTPCode_Target_3XX_Count = 100,
        HTTPCode_Target_4XX_Count = 100
    } 
    elb_thresholds = {
        SurgeQueueLength = 12313,
        RequestCount = 200,
        BackendConnectionErrors = 100,
        HTTPCode_ELB_5XX = 200,
        Latency = 10,
        HTTPCode_Backend_3XX = 12313,
        HTTPCode_Backend_4XX = 123123
    }
}