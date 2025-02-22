// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Communication {

    // Structure pour représenter un message
    struct Message {
        address sender;
        address receiver;
        string message;
        uint256 timestamp;
    }

    // Tableau pour stocker l'historique des messages
    Message[] public messages;

    // Événement émis à chaque fois qu'un message est envoyé
    event MessageSent(address indexed sender, address indexed receiver, string message, uint256 timestamp);

    // Fonction pour envoyer un message à un autre utilisateur
    function sendMessage(address receiver, string memory message) public {
        require(bytes(message).length > 0, "Le message ne peut pas être vide");
        require(receiver != msg.sender, "Vous ne pouvez pas vous envoyer un message à vous-même");

        // Enregistrement du message
        messages.push(Message({
            sender: msg.sender,
            receiver: receiver,
            message: message,
            timestamp: block.timestamp
        }));

        // Déclenchement de l'événement
        emit MessageSent(msg.sender, receiver, message, block.timestamp);
    }

    // Fonction pour récupérer l'historique des messages envoyés par l'utilisateur
    function getMessages() public view returns (Message[] memory) {
        Message[] memory userMessages = new Message[](messages.length);
        uint256 count = 0;

        // On parcourt tous les messages pour trouver ceux envoyés par l'utilisateur
        for (uint256 i = 0; i < messages.length; i++) {
            if (messages[i].sender == msg.sender || messages[i].receiver == msg.sender) {
                userMessages[count] = messages[i];
                count++;
            }
        }

        // Retourner uniquement les messages filtrés pour l'utilisateur
        Message[] memory result = new Message[](count);
        for (uint256 j = 0; j < count; j++) {
            result[j] = userMessages[j];
        }
        
        return result;
    }

    // Fonction pour récupérer un message spécifique par son index
    function getMessage(uint256 index) public view returns (address sender, address receiver, string memory message, uint256 timestamp) {
        require(index < messages.length, "Message non trouvé");
        
        Message memory msgObj = messages[index];
        return (msgObj.sender, msgObj.receiver, msgObj.message, msgObj.timestamp);
    }
}
