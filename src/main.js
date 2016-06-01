import React from 'react';
import ReactDOM from 'react-dom';

import './stylesheets/modules/main.less';
import './stylesheets/modules/flashcard.less';
import './stylesheets/utilities/clear-floats.less';
import './stylesheets/utilities/pull-right.less';
import './stylesheets/utilities/text-center.less';
import './stylesheets/utilities/hide.less';
import './stylesheets/modules/controls.less';
import './stylesheets/utilities/buttons.less';
import './stylesheets/utilities/fontstyles.less';
import './stylesheets/utilities/inputstyles.less';

import {Vocabulary} from './words';

export class Page extends React.Component {
    constructor() {
        super();
        this.selectList = 'MounceCh1';
        this.words = this.getWordList();
        this.wordIndex = 0;
        this.vocabularyList = Vocabulary.List;
        //this.randomNumber = Math.floor((Math.random() * this.words.length));
    }
    getWordList() {
        let wordlist = Vocabulary[this.selectList];
        this.shuffle(wordlist);
        return wordlist;
    }

    shuffle(arr) {
        var currentIndex = arr.length,
            temporaryValue,
            randomIndex;

        // While there remain elements to shuffle...
        while (0 !== currentIndex) {

            // Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex -= 1;

            // And swap it with the current element.
            temporaryValue = arr[currentIndex];
            arr[currentIndex] = arr[randomIndex];
            arr[randomIndex] = temporaryValue;
        }

        return arr;
    }
    shuffleCards(e) {
        e.preventDefault();
        document.getElementById('cardface').style.display = "block";
        document.getElementById('answer').style.display = "none";
        this.wordIndex = 0;
        this.words = this.getWordList();
        this.forceUpdate();
    }
    handleShowDef(e) {
        e.preventDefault();
        document.getElementById('cardface').style.display = "none";
        document.getElementById('answer').style.display = "block";
    }
    handleGetNextWord(e) {
        e.preventDefault();
        //get next word
        document.getElementById('cardface').style.display = "block";
        document.getElementById('answer').style.display = "none";
        //this.randomNumber = Math.floor((Math.random() * this.words.length));
        this.wordIndex++;
        this.forceUpdate();
    }
    pickVocabList(e) {
        e.preventDefault();
        var e = document.getElementById("selectVocabList");
        this.selectList = e.options[e.selectedIndex].value;
        this.words = this.getWordList();
        this.forceUpdate();
    }
    render() {
        var vocabLists = this.vocabularyList.map(function(list) {
            return (
                <option key={list}>
                    {list}
                </option>
            );
        });
        return (
            <div id="main">
                <div className='text-center'>
                    <select className="selectList" id="selectVocabList">
                        {vocabLists}
                    </select>
                    <button className="button button-blue" onClick={(e) => this.pickVocabList(e)}>Change Lists</button>
                </div>
                <div id="flashcard">
                    <span className="pull-right">
                        <span className="italics">Frequency:
                        </span>{this.words[this.wordIndex].numOfTimesInNT}x</span>
                    <div className="clear-floats"></div>
                    <h2 id="cardface" className="text-center drop-down">{this.words[this.wordIndex].word}</h2>

                    <div id="answer" style={{
                        display: 'none'
                    }}>
                        <h3 className="text-center">
                            <span className="italics">Definition:
                            </span>{this.words[this.wordIndex].definition}</h3>
                        <br/>
                        <h3 className="text-center">
                            <span className="italics">Definite Article:
                            </span>{this.words[this.wordIndex].definiteArticle}</h3>
                        <br/>
                        <h3 className="text-center">
                            <span className="italics">Other Forms:<br/></span>
                        </h3>
                    </div>
                </div>
                <div id="controls">
                    <div className="center">
                        <button className="button button-blue" onClick={(e) => this.shuffleCards(e)}>Shuffle Cards</button>
                        <button className="button button-blue" onClick={(e) => this.handleShowDef(e)}>Show Definition</button>
                        <button className="button button-blue" onClick={(e) => this.handleGetNextWord(e)}>Next Word</button>
                    </div>
                </div>
            </div>
        );
    }
}

ReactDOM.render(
    <Page/>, document.getElementById("app"));
