# KVstorageBaseRaft-cpp

這是一個用 C++ 編寫的分布式 Key-Value 存儲系統，基於 Raft 協議實現。主要目的是幫助大家理解分布式一致性協議的原理和實踐過程。適合學習、課程設計和分布式系統入門。

> 本項目僅供學習和研究，請勿用於生產環境。

## 項目特色
- 基於 Raft 協議，實現分布式 KV 存儲
- 支持 RPC 通訊、節點選舉、日誌複製等核心功能
- 結構清晰，易於閱讀和擴展

## 依賴安裝
請先安裝以下依賴（以 Ubuntu 為例）：
```bash
sudo apt-get install libboost-dev libboost-all-dev
sudo apt-get install protobuf-compiler libprotobuf-dev
# muduo 請參考官方文檔安裝
```
建議 protobuf 版本 3.12.4 及以上。

## 編譯與運行
1. 進入項目目錄，創建構建目錄並編譯：
    ```bash
    mkdir build
    cd build
    cmake ..
    make
    ```
2. 運行 RPC 服務端與客戶端：
    ```bash
    ./provider
    ./consumer
    ```
   請先啟動 provider，再啟動 consumer。

3. 運行 Raft 集群：
    ```bash
    ./raftCoreRun -n 3 -f test.conf
    ```

## 目錄結構
- `src/`：核心源碼
- `example/`：示例代碼
- `docs/`：文檔與圖片
- `test/`：測試代碼

## 聯絡與貢獻
歡迎大家提出 issue 或 PR，一起完善這個學習型項目！

---

如需更多幫助或有建議，請在 GitHub 上聯絡我。

## 分支說明
- main：最新內容，已經實現一個簡單的clerk
- rpc：基於muduo和rpc框架相關內容
- raft_DB：基於Raft的k-v存儲數據庫，主要用於觀察選舉過程

## 使用方法

### 1.庫準備
- muduo
- boost
- protoc
- clang-format（可選）

**安裝說明**

- clang-format，如果你不設計提交pr，那麼不用安裝，這裡也給出安裝命令:`sudo apt-get install clang-format`
- protoc，本地版本為3.12.4，ubuntu22使用`sudo apt-get install protobuf-compiler libprotobuf-dev`安裝默認就是這個版本
- boost，`sudo apt-get install libboost-dev libboost-test-dev libboost-all-dev`
- muduo,https://blog.csdn.net/QIANGWEIYUAN/article/details/89023980
> 如果庫安裝編譯本倉庫的時候有錯誤或者需要確認版本信息，可以在issue頁面查看其他人遇到問題和分享： [鏈接](https://github.com/youngyangyang04/KVstorageBaseRaft-cpp/issues)

### 2.編譯啟動

#### 先啟動rpc
```
cd KVstorageBaseRaft-cpp // 進入項目目錄
mkdir cmake-build-debug
cd cmake-build-debug
cmake ..
make
```
之後在目錄bin就有對應的可執行文件生成：

* provider
* consumer

```
./provider
``` 

![](docs/images/rpc1.jpg)

換一個窗口，在執行 consumer 

```
./consumer
``` 

![](docs/images/rpc2.jpg)

運行即可，注意先運行provider，再運行consumer，原因很簡單：需要先提供rpc服務，才能去調用。

#### 使用raft集群
之後在目錄bin就有對應的可執行文件生成，
```
// make sure you in bin directory ,and this has a test.conf file
./raftCoreRun -n 3 -f test.conf
```

![](docs/images/raft.jpg)

這裡更推薦一鍵運行，使用clion/clion nova，點擊這個按鈕即可：

![img.png](docs/images/img.png)

正常運行後，命令行應該有如下raft的運行輸出：
```
20231228 13:04:40.570744Z 615779 INFO  TcpServer::newConnection [RpcProvider] - new connection [RpcProvider-127.0.1.1:16753#2] from 127.0.0.1:37234 - TcpServer.cc:80
[2023-12-28-21-4-41] [Init&ReInit] Sever 0, term 0, lastSnapshotIncludeIndex {0} , lastSnapshotIncludeTerm {0}
[2023-12-28-21-4-41] [Init&ReInit] Sever 1, term 0, lastSnapshotIncludeIndex {0} , lastSnapshotIncludeTerm {0}
[2023-12-28-21-4-41] [Init&ReInit] Sever 2, term 0, lastSnapshotIncludeIndex {0} , lastSnapshotIncludeTerm {0}
[2023-12-28-21-4-41] [       ticker-func-rf(1)              ]  選舉定時器到期且不是leader，開始選舉

[2023-12-28-21-4-41] [func-sendRequestVote rf{1}] 向server{1} 發送 RequestVote 開始
[2023-12-28-21-4-41] [func-sendRequestVote rf{1}] 向server{1} 發送 RequestVote 開始
[2023-12-28-21-4-41] [func-sendRequestVote rf{1}] 向server{1} 發送 RequestVote 完畢，耗時:{0} ms
[2023-12-28-21-4-41] [func-sendRequestVote rf{1}] elect success  ,current term:{1} ,lastLogIndex:{0}

[2023-12-28-21-4-41] [func-sendRequestVote rf{1}] 向server{1} 發送 RequestVote 完畢，耗時:{0} ms
[2023-12-28-21-4-41] [func-Raft::doHeartBeat()-Leader: {1}] Leader的心跳定時器觸發了

[2023-12-28-21-4-41] [func-Raft::doHeartBeat()-Leader: {1}] Leader的心跳定時器觸發了 index:{0}

[2023-12-28-21-4-41] [func-Raft::doHeartBeat()-Leader: {1}] Leader的心跳定時器觸發了 index:{2}

[2023-12-28-21-4-41] [func-Raft::sendAppendEntries-raft{1}] leader 向節點{0}發送AE rpc開始 ， args->entries_size():{0}
[2023-12-28-21-4-41] [func-Raft::sendAppendEntries-raft{1}] leader 向節點{2}發送AE rpc開始 ， args->entries_size():{0}
[2023-12-28-21-4-41] [func-Raft::doHeartBeat()-Leader: {1}] Leader的心跳定時器觸發了
```

#### 使用kv
在啟動raft集群之後啟動`callerMain`即可。

## todoList

- [x] 完成raft節點的集群功能
- [ ] 去除冗餘的庫：muduo、boost 
- [ ] 代碼精簡優化
- [x] code format
- [ ] 代碼解讀 maybe

## 貢獻者列表

<!-- readme: contributors -start -->
<!-- readme: contributors -end -->

## Star History

<a href="https://star-history.com/#youngyangyang04/KVstorageBaseRaft-cpp&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=youngyangyang04/KVstorageBaseRaft-cpp&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=youngyangyang04/KVstorageBaseRaft-cpp&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=youngyangyang04/KVstorageBaseRaft-cpp&type=Date" />
  </picture>
</a>


