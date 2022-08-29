// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

// TODO: replace with standard contract from openzeppelin library
interface ERC20 {
    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);
}

// TODO: move these interfaces to a separate file in Compound package
interface CErc20 {
    function mint(uint256) external returns (uint256);

    function borrow(uint256) external returns (uint256);

    function borrowRatePerBlock() external view returns (uint256);

    function borrowBalanceCurrent(address) external returns (uint256);

    function repayBorrow(uint256) external returns (uint256);

}


interface CEth {
    function mint() external payable;

    function borrow(uint256) external returns (uint256);

    function repayBorrow() external payable;

    function borrowBalanceCurrent(address) external returns (uint256);
}


interface Comptroller {
    function markets(address) external returns (bool, uint256);

    function enterMarkets(address[] calldata) external returns (uint256[] memory);

    function getAccountLiquidity(address) external view returns (uint256, uint256, uint256);
}


contract MyContract {
    event MyLog(string, uint256);
    // TODO: move these addresses to config & support Mainnet
    // https://github.com/compound-finance/compound-config/blob/master/networks/goerli.json

    address goerli_comptroller = 0x627EA49279FD0dE89186A58b8758aD02B6Be2867;
    address goerli_COMP = 0xe16C7165C8FeA64069802aE4c4c9C320783f2b6e;
    address goerli_Timelock = 0x25e46957363e16C4e2D5F2854b062475F9f8d287;
    address goerli_cBAT = 0xCCaF265E7492c0d9b7C2f0018bf6382Ba7f0148D;
    address goerli_cDAI = 0x822397d9a55d0fefd20F5c4bCaB33C5F65bd28Eb;
    address goerli_cEth = 0x20572e4c090f15667cF7378e16FaD2eA0e2f3EfF;
    address goerli_cREP = 0x1d70B01A2C3e3B2e56FcdcEfe50d5c5d70109a5D;
    address goerli_cSAI = 0x5D4373F8C1AF21C391aD7eC755762D8dD3CCA809;
    address goerli_cUSDC = 0xCEC4a43eBB02f9B80916F1c718338169d6d5C1F0;
    address goerli_cWBTC = 0x6CE27497A64fFFb5517AA4aeE908b1E7EB63B9fF;
    address goerli_cZRX = 0xA253295eC2157B8b69C44b2cb35360016DAa25b1;

    function myErc20RepayBorrow(
        address _erc20Address,
        address _cErc20Address,
        uint256 amount
    ) public returns (bool) {
        ERC20 underlying = ERC20(_erc20Address);
        CErc20 cToken = CErc20(_cErc20Address);

        underlying.approve(_cErc20Address, amount);
        uint256 error = cToken.repayBorrow(amount);

        require(error == 0, "CErc20.repayBorrow Error");
        return true;
    }

    function myEthRepayBorrow(address _cEtherAddress, uint256 amount, uint256 gas)
    public
    returns (bool)
    {
        CEth cEth = CEth(_cEtherAddress);
        cEth.repayBorrow{ value: amount, gas: gas }();
        return true;
    }

    // Need this to receive ETH when `borrowEthExample` executes
    receive() external payable {}
}