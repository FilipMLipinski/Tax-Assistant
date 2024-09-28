import Conversation from "./Conversation"
import UserInput from "./UserInput"

export default function ChatWindow(){
    return(
        <div id="chatWindow">
            <Conversation />
            <UserInput />
        </div>
    )
}