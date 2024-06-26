// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

interface IERC721Metadata {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC4973 {
    /// @dev This emits when ownership of any ABT changes by any mechanism.
    ///  This event emits when ABTs are given or equipped and unequipped
    ///  (`to` == 0).
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /// @notice Count all ABTs assigned to an owner
    /// @dev ABTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param owner An address for whom to query the balance
    /// @return The number of ABTs owned by `address owner`, possibly zero
    function balanceOf(address owner) external view returns (uint256);

    /// @notice Find the address bound to an ERC4973 account-bound token
    /// @dev ABTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param tokenId The identifier for an ABT.
    /// @return The address of the owner bound to the ABT.
    function ownerOf(uint256 tokenId) external view returns (address);

    /// @notice Removes the `uint256 tokenId` from an account. At any time, an
    ///  ABT receiver must be able to disassociate themselves from an ABT
    ///  publicly through calling this function. After successfully executing this
    ///  function, given the parameters for calling `function give` or
    ///  `function take` a token must be re-equipable.
    /// @dev Must emit a `event Transfer` with the `address to` field pointing to
    ///  the zero address.
    /// @param tokenId The identifier for an ABT.
    function unequip(uint256 tokenId) external;

    /// @notice Creates and transfers the ownership of an ABT from the
    ///  transaction's `msg.sender` to `address to`.
    /// @param to The receiver of the ABT.
    /// @param uri A distinct Uniform Resource Identifier (URI) for a given ABT.
    /// @return A unique `uint256 tokenId`.
    function give(address to, string calldata uri) external returns (uint256);

    /// @notice Creates and transfers the ownership of an ABT from an
    /// `address from` to the transaction's `msg.sender`.
    /// @param from The origin of the ABT.
    /// @param uri A distinct Uniform Resource Identifier (URI) for a given ABT.
    /// @return A unique `uint256 tokenId` generated by type-casting the `bytes32`
    function take(address from, string calldata uri) external returns (uint256);
}

contract ERC4973 is ERC165, IERC721Metadata, IERC4973 {
    string private _name;
    string private _symbol;
    uint256 private counter;

    mapping(uint256 => address) private _owners;
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => uint256) private _balances;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        counter = 0;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC4973).interfaceId;
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(_exists(tokenId), "tokenURI: token doesn't exist");
        return _tokenURIs[tokenId];
    }

    function balanceOf(address owner) public view override returns (uint256) {
        // require(owner != address(0), "balanceOf: address zero is not a valid owner");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ownerOf: token doesn't exist");
        return owner;
    }

    function unequip(uint256 tokenId) public override {
        require(
            msg.sender == ownerOf(tokenId),
            "unequip: sender must be owner"
        );
        _burn(tokenId);
    }

    function give(
        address to,
        string calldata uri
    ) external override returns (uint256) {
        require(msg.sender != to, "give: cannot give from self");
        counter += 1;
        uint256 tokenId = counter;
        _mint(msg.sender, to, tokenId, uri);
        return tokenId;
    }

    function take(
        address from,
        string calldata uri
    ) external override returns (uint256) {
        require(msg.sender != from, "take: cannot take from self");
        counter += 1;
        uint256 tokenId = counter;
        _mint(from, msg.sender, tokenId, uri);
        return tokenId;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _mint(
        address from,
        address to,
        uint256 tokenId,
        string memory uri
    ) internal virtual returns (uint256) {
        require(!_exists(tokenId), "mint: tokenID exists");
        _balances[to] += 1;
        _owners[tokenId] = to;
        _tokenURIs[tokenId] = uri;
        emit Transfer(from, to, tokenId);
        return tokenId;
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
}
