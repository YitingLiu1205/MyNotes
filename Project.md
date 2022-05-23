## Resources
- [Demo serialized file](https://microsoft.sharepoint.com/teams/PromoteIQCN/Shared%20Documents/Forms/AllItems.aspx?viewid=73a98dce%2D1245%2D43ec%2Da3f8%2Db0572ea39c86&id=%2Fteams%2FPromoteIQCN%2FShared%20Documents%2FGeneral%2FDelivery%20Engine%2FDE%5Fbrownbag%5Fmaterials%2Fdemo%2Dserialized%2Dfile)

## Dictionary

- 信息流主要计费方式
  - CPC: 每个点击成本，即按点击付费，比如点击一次广告，就扣费
  - CPM: 千次曝光成本，即按千次展示付费
- PPC: 
- CTR (Click-Through-Rate): 
  - 指对移动广告推广活动展示的点击次数比值
  - `CTR (%) = 移动广告推广活动的点击次数 / 展示总数量`
- CVR: 
- ROI (Return on Investment): 
  - 投资回报率，简单理解就是净利润与成本的比率
- RPM: 
- SSP (Sell-Side Platform): 供应方平台
  - SSP平台可以帮助发行商（也可能是app开发者）流量变现。SSP可以使发布商将其广告资源提供给广告交易平台，并设置控件以在所有需求来源中最大化其广告展示的收益。 这包括设置最低定价水平，允许的广告商和接受的类别的规则，广告类型等。
- DSP (Demand-Side Platform): 需求方平台
  - 是为广告主、代理商提供一个综合性的管理平台，通过统一界面管理多个数字广告和数据交换账户
- ADX: 广告交易平台
  - ADX是广告交易平台，可以实现SSP和DSP的相互连接。 它是一个中立的自主平台，可通过实时竞价完成整个竞价过程

### Delivery Terminology

#### Players 主要角色
- Retailer (Publisher) 网站主:
  - refers to e-commerce site where advertising campaigns are running​
- Vendors (Brands) 广告主: 
  - refers to the advertisers who are running ad campaigns on retailer websites​

#### Supply Side​ 
- Slot: 
  - locations on site of retailers where ads are eligible to render, e.g., “Top Row; Search Result Pages”​
- Placement: 
  - a collection of inventory/slots. When a campaign is set up, the user chooses a placement, and ads on this campaign will be served to the corresponding slot(s)​
- Opportunity: 
  - when a retailer makes an ad request call to the PIQ request API, PIQ logs that request as an opportunity, which is a discrete request for a count of products, to a specific slot, for a specific piece of inventory​
- Category Target Value: 
  - a taxonomy tree of product, critical signal for ads-selection. Data of target value is loaded from catalog of retailers, and bind with content (product), campaigns, and placement for delivery execution​
- Requested Targets: 
  - the target value that retailers send over to PromoteIQ as advertisement opportunities​
- Count: 
  - refers to the number of products that PIQ will return to a request from retailer for a given piece of inventory​
- Count fill: 
  - refers to the number of products that the retailer intends to render in a piece of inventory

#### Metrics
- Deferred Impression:  
  - a server-side record of each PIQ ad server response for an ad request (Opportunity)​
- Impression: 
  - for an ad renders at least one pixel on the user's page​
- View: for 50%+ of an ad in viewport for at least one second​
- Click: for any click or other intent-driven user interaction with a promoted product​
- Conversion: is attributed when a customer purchases a product that was run in a campaign. Purchases can be called conversions if there was an impression within 28 days of purchase​
- Fill Rate: Impressions / Opportunities​
- Render Rate: Impressions / Ad Responses (Deferred Impressions)​
- Response Rate: Responses / Opportunities

#### E-Commerce
- PDP (Product Detail Page)/PIP (Product Information Page) : retailer page that displays details about a specific product​
- PLP (Product Listing Page): on retailer site, this is the page of products that displays when a user uses the search tool or browses categories​


### Dataflow
- PIQ DBase (promote-prod)
  - PIQ DB -> Queries -> Serializer
  - includes:
    - campaigns
    - contents
    - target_values
    - placements
    - slots
    - templates
- PIQ DWare (promote-prod-rpt)
  - Event logs -> PIQ DW -> Serializer
  - includes:
    - performance_campaign
    - budget_campaigns
- Chameleon (API Server)
    - DataFeedLoader -> ES -> Chameleon -> API Calls -> Serializer
    - 
- Aerospike

## Serializer

- [Overview](https://spotfront.atlassian.net/wiki/spaces/EN/pages/1198325768/Delivery-Serializer)
- DB + Chameleon -> 在不同System中生成不同.ser结果 -> 合成 -> Output -> Upload to `AWS s3 bucket`

### Subsystem Input & Output
- [Output](https://spotfront.atlassian.net/wiki/spaces/EN/pages/1199800456/Serializer+Output)

#### Creative System
- Domain def.: A creative is any data that is used to deliver a single promotion to a shopper. It is also a rendered promotion for a shopper. 
- Input
  - Chameleon API
  - DB-1
  - DW-1 redshift
- Output
  - **CreativeMap**: `Map<String, Creative>`
  - **ContentMap**: `Map<Integer, Content>`
  - **CreativesByCampaign**: `Map<Integer, Set<Creative>>`
- Get data
  - `featureFlag.isLoadingDataConcurrentlyEnabled()`: 控制loading db method (concurrently or sequentially) => `dataset` include = 20 Maps
    - **Concurrently**:
      - Return contents same as `sequentially`
    - **Sequentially**:
      - 13 Maps: 直接从Subservice获得
        - 每个Service获取的方法：
          - `SQL` -> Stream -> Collect -> Map
      - 7 Maps: Optional, controlled by `featureFlag`
  - `reportRawDataInDatabaseByPublisherId(dataSets)`
    - 用于统计`campaignMapSize`, `campaignContentMapSize`, `contentMapSize`
  - `mapProductResponseAndContent` => Content
  - `removeUnavailableProducts` => Change content
  - `addContentTargetsToContents`
  - `filterCampaignContentsByCampaignIds`
  - ...
  - => Return `CreativeSystem`

#### Placement Slot System
- Input
- Output
  - **PlacementSlotMap**: `Map<String, List<PlacementSlot>>`

#### Slot System
- Input
- Output
  - **SlotMap**: `Map<Integer, Slot>`

#### Target Value System
- Input
- Output
  - **TargetDimensionsMap**: `Map<Integer, TargetDimensions>`
  - **TargetValueRefMap**: `Map<TargetDimension, Map<String, TargetValue>>`
  - **TargetValueMap**: `Map<Integer, TargetValue>`
  - **TargetValueComponentMap**: `Map<Integer, TargetValueComponent>`
  - **TargetValueMemberMap**: `Map<Integer, TargetValueMember>`

#### Template System
- Input
- Output
  - **TemplateMap**: `Map<Integer, Template>`

#### Write Data
- Use `writeObject(Object object, String filename, boolean useGzip)`
  - 需要压缩
    - FileOutputStream: 用于将数据（以字节为单位）写入文件
    - GZIPOutputStream
    - ObjectOutputStream: 把对象转成字节数据, 输出到文件中保存，对象的输出过程称为序列化，可实现对象的持久存储
  - 不需要压缩
    - FileOutputStream
    - ObjectOutputStream

### Serializer Output




## Adserver reload section
