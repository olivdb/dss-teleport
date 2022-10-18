all             :; DAPP_BUILD_OPTIMIZE=1 DAPP_BUILD_OPTIMIZE_RUNS=200 dapp --use solc:0.8.15 build
clean           :; dapp clean
test            :; ./test.sh $(match) $(runs)
cov             :; DAPP_BUILD_OPTIMIZE=1 DAPP_BUILD_OPTIMIZE_RUNS=200 dapp --use solc:0.8.15 test -v --coverage --cov-match "src\/Teleport"
certora-con-fee :; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.15/solc-0.8.15 --optimize_map TeleportConstantFee=200 --rule_sanity basic src/TeleportConstantFee.sol --verify TeleportConstantFee:certora/TeleportConstantFee.spec $(if $(rule),--rule $(rule),) --multi_assert_check --short_output
certora-lin-fee :; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.15/solc-0.8.15 --optimize_map TeleportLinearFee=200 --rule_sanity basic src/TeleportLinearFee.sol --verify TeleportLinearFee:certora/TeleportLinearFee.spec $(if $(rule),--rule $(rule),) --multi_assert_check --short_output
certora-join    :; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.15/solc-0.8.15 --optimize_map TeleportJoin=200,FeesMock=0,Auxiliar=0,VatMock=0,DaiMock=0,DaiJoinMock=0 --rule_sanity basic src/TeleportJoin.sol certora/FeesMock.sol certora/Auxiliar.sol src/test/mocks/VatMock.sol src/test/mocks/DaiMock.sol src/test/mocks/DaiJoinMock.sol --link TeleportJoin:vat=VatMock TeleportJoin:daiJoin=DaiJoinMock DaiJoinMock:vat=VatMock DaiJoinMock:dai=DaiMock --verify TeleportJoin:certora/TeleportJoin.spec $(if $(rule),--rule $(rule),) --multi_assert_check --short_output --settings -mediumTimeout=30
certora-router  :; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.15/solc-0.8.15 --optimize_map TeleportRouter=200,TeleportJoinMock=0,DaiMock=0 --rule_sanity basic src/TeleportRouter.sol certora/TeleportJoinMock.sol src/test/mocks/DaiMock.sol --link TeleportRouter:dai=DaiMock --verify TeleportRouter:certora/TeleportRouter.spec $(if $(rule),--rule $(rule),) --multi_assert_check --short_output
certora-oracle  :; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.15/solc-0.8.15 --optimize_map TeleportOracleAuth=200,TeleportJoinMock=0,Auxiliar=0 --rule_sanity basic src/TeleportOracleAuth.sol certora/TeleportJoinMock.sol certora/Auxiliar.sol --link TeleportOracleAuth:teleportJoin=TeleportJoinMock Auxiliar:oracle=TeleportOracleAuth --verify TeleportOracleAuth:certora/TeleportOracleAuth.spec --loop_iter 10 --optimistic_loop $(if $(rule),--rule $(rule),) --multi_assert_check --short_output
