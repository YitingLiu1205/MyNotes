
## Dictionary

- 信息流主要计费方式
  - CPC: 每个点击成本，即按点击付费，比如点击一次广告，就扣费
  - CPM: 千次曝光成本，即按千次展示付费
- PPC: 
- CTR: 
- CVR: 
- ROI: 
- RPM: 
- SSP: Sell-Side Platform 供应方平台
  - SSP平台可以帮助发行商（也可能是app开发者）流量变现。SSP可以使发布商将其广告资源提供给广告交易平台，并设置控件以在所有需求来源中最大化其广告展示的收益。 这包括设置最低定价水平，允许的广告商和接受的类别的规则，广告类型等。
- DSP: Demand-Side Platform 需求方平台
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
- Input
- Output
  - **CreativeMap**: `Map<String, Creative>`
  - **ContentMap**: `Map<Integer, Content>`
  - **CreativesByCampaign**: `Map<Integer, Set<Creative>>`

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

### Serializer Output



## Serializer Improvement

### Problems
- Problem 1: AD Server使用Serializer结果时，会出现Java GC导致的扩容问题
  - How it happened?
    - 

### Performance
可能可以改进的方面：
- 

