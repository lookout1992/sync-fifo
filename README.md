# sync-fifo
code for sync-fifo, the reading time of SARM is delayed 1 cycle.
同步FIFO中SRAM的读逻辑为：使能有效的下一个时钟周期，数据被读出。

# 2020/06/27
调试环境，目前sync-fifo代码并不能跑通，目前仅上传用于测试。

# 2020/06/28
重新设计sync_fifo，其中sram读使能有效的下一拍读书据输出。
本设计sram使用寄存器模型，且使用双口同时读写模型。单口sram设计到读写双ram乒乓操作，不是本设计重点，略过。
