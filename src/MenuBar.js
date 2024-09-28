import Logo from "./Logo";
import Language from "./Language";
import ExternalLink from "./ExternalLink";

export default function MenuBar(){
    return(
        <div id="menuBar">
            <Logo />
            <Language />
            <ExternalLink />
        </div>
    );
}