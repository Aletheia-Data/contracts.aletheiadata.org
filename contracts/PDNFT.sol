// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PDNft is ERC721URIStorage, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private supply;

    string public uriPrefix = "";
    string public hiddenMetadataUri;

    uint256 public cost = 0.5 ether; // MATIC on polygon
    uint256 public maxMintAmountPerTx = 1;

    bool public paused = true;
    bool public revealed = false;

    mapping(uint256 => string) private _tokenURIs;

    mapping(string => uint256[]) Cids;

    constructor() ERC721("Public Data NFT", "PDNFT") {
        setHiddenMetadataUri(
            "ipfs://QmVcC9mH4gV9BbdjqwibuCT6cpUHbRtqYR79QKjuS4QwvB/hidden.json" // TODO: change hide file
        );
        setUriPrefix("ipfs://");
    }

    modifier mintCompliance(uint256 _mintAmount) {
        require(
            _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
            "Invalid mint amount!"
        );
        _;
    }

    function addCid(string memory _cid, uint256 _tokenId) internal {
        Cids[_cid].push(_tokenId);
    }

    // Return array of bytes32 as solidity doesn't support returning string arrays yet
    function getTokensCID(string memory _cid)
        public
        view
        returns (uint256[] memory)
    {
        return Cids[_cid];
    }

    function totalSupply() public view returns (uint256) {
        return supply.current();
    }

    function mint(uint256 _mintAmount, string memory _metadata, string memory _cid)
        public
        payable
        mintCompliance(_mintAmount)
    {
        require(!paused, "The contract is paused!");

        require(msg.value >= cost * _mintAmount, "Insufficient funds!");

        _mintLoop(msg.sender, _mintAmount, _metadata, _cid);
    }

    function mintForAddress(
        uint256 _mintAmount,
        address _receiver,
        string memory _metadata,
        string memory _cid
    ) public mintCompliance(_mintAmount) onlyOwner {
        _mintLoop(_receiver, _mintAmount, _metadata, _cid);
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
        uint256 currentTokenId = 1;
        uint256 ownedTokenIndex = 0;

        while (ownedTokenIndex < ownerTokenCount) {
            address currentTokenOwner = ownerOf(currentTokenId);

            if (currentTokenOwner == _owner) {
                ownedTokenIds[ownedTokenIndex] = currentTokenId;

                ownedTokenIndex++;
            }

            currentTokenId++;
        }

        return ownedTokenIds;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return hiddenMetadataUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(abi.encodePacked(currentBaseURI, _tokenURIs[_tokenId]))
                : "";
    }

    function _setTokenURI(uint256 _tokenId, string memory _metadata, string memory _cid)
        internal
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[_tokenId] = _metadata;
        addCid(_cid, _tokenId);
    }

    function setRevealed(bool _state) public onlyOwner {
        revealed = _state;
    }

    function setCost(uint256 _cost) public onlyOwner {
        cost = _cost;
    }

    function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
        public
        onlyOwner
    {
        maxMintAmountPerTx = _maxMintAmountPerTx;
    }

    function setHiddenMetadataUri(string memory _hiddenMetadataUri)
        public
        onlyOwner
    {
        hiddenMetadataUri = _hiddenMetadataUri;
    }

    function setUriPrefix(string memory _uriPrefix) public onlyOwner {
        uriPrefix = _uriPrefix;
    }

    function setPaused(bool _state) public onlyOwner {
        paused = _state;
    }

    function withdraw() public onlyOwner {
        // This will pay 5% of the initial sale.
        // =============================================================================
        // (bool hs, ) = payable("0x10....").call{value: (address(this).balance * 5) / 100}("");
        // require(hs);
        // =============================================================================

        // This will transfer the remaining contract balance to the owner.
        // Do not remove this otherwise you will not be able to withdraw the funds.
        // =============================================================================
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
        // =============================================================================
    }

    function _mintLoop(
        address _receiver,
        uint256 _mintAmount,
        string memory _metadata,
        string memory _cid
    ) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            supply.increment();
            uint256 tokenId = supply.current();
            _safeMint(_receiver, tokenId);
            _setTokenURI(tokenId, _metadata, _cid);
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return uriPrefix;
    }
}
