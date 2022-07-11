echo link hydra-v1.14.0-serializer to current
ln -snf /apps/delivery/serialized-data/hydra-v1.14.0-serializer /apps/delivery/serialized-data/current
echo reload creativeSystem
curl -s http://127.0.0.1:8081/reload?system=creativeSystem
echo reload targetValueSystem
curl -s http://127.0.0.1:8081/reload?system=targetValueSystem
echo reload placementSlotSystem
curl -s http://127.0.0.1:8081/reload?system=placementSlotSystem
echo reload templateSystem
curl -s http://127.0.0.1:8081/reload?system=templateSystem
echo reload slotSystem
curl -s http://127.0.0.1:8081/reload?system=slotSystem
echo reload keywordTargetingSystem
curl -s http://127.0.0.1:8081/reload?system=keywordTargetingSystem

# echo link hydra-v1.14.1-serializer to current
# ln -snf /apps/delivery/serialized-data/hydra-v1.14.1-serializer /apps/delivery/serialized-data/current
# echo reload creativeSystem
# curl -s http://delivery-2-000001.newegg.prod.oma.ms.promoteiq.vpc:8081/reload?system=creativeSystem
# echo reload targetValueSystem
# curl -s http://delivery-2-000001.newegg.prod.oma.ms.promoteiq.vpc:8081/reload?system=targetValueSystem
# echo reload placementSlotSystem
# curl -s http://delivery-2-000001.newegg.prod.oma.ms.promoteiq.vpc:8081/reload?system=placementSlotSystem
# echo reload templateSystem
# curl -s http://delivery-2-000001.newegg.prod.oma.ms.promoteiq.vpc:8081/reload?system=templateSystem
# echo reload slotSystem
# curl -s http://delivery-2-000001.newegg.prod.oma.ms.promoteiq.vpc:8081/reload?system=slotSystem
# echo reload keywordTargetingSystem
# curl -s http://delivery-2-000001.newegg.prod.oma.ms.promoteiq.vpc:8081/reload?system=keywordTargetingSystem