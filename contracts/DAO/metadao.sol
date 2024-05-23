pragma solidity ^0.8.9;

contract MetaDAO {
    event PostCreated(
        bytes32 indexed postId,
        address indexed postOwner,
        bytes32 indexed parentId,
        bytes32 contentId,
        bytes32 categoryId
    );
    event ContentAdded(bytes32 indexed contentId, string contentUri);
    event CategoryCreated(bytes32 indexed categoryId, string category);
    event Voted(
        bytes32 indexed postId,
        address indexed postOwner,
        address indexed voter,
        uint80 reputationPostOwner,
        uint80 reputationVoter,
        int40 postVotes,
        bool up,
        uint8 reputationAmount
    );

    struct post {
        address postOwner;
        bytes32 parentPost;
        bytes32 contentId;
        int40 votes;
        bytes32 categoryId;
    }

    mapping(address => mapping(bytes32 => uint80)) reputationRegistry;
    mapping(bytes32 => string) categoryRegistry;
    mapping(bytes32 => string) contentRegistry;
    mapping(bytes32 => post) postRegistry;
    mapping(address => mapping(bytes32 => bool)) voteRegistry;

    function createPost(
        bytes32 _parentId,
        string calldata _contentUri,
        bytes32 _categoryId
    ) external {}

    function voteUp(bytes32 _postId, uint8 _reputationAdded) external {}

    function voteDown(bytes32 _postId, uint8 _reputationTaken) external {}

    function validateReputationChange(
        address _sender,
        bytes32 _categoryId,
        uint8 _reputationAdded
    ) internal view returns (bool _result) {}

    function addCategory(string calldata _category) external {}

    function getContent(
        bytes32 _contentId
    ) public view returns (string memory) {}
}
