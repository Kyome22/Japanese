//
//  Katakana.swift
//  
//
//  Created by Kyomesuke3 on 2018/01/13.
//  Copyright © 2018年 Kyomesuke3. All rights reserved.
//

import Foundation

class Japanese {

	private func transliterateString(source: String, transform: CFString, reverse: Bool) -> String {
		let string = CFStringCreateMutableCopy(kCFAllocatorDefault, 0, source as CFString)
		if CFStringTransform(string, nil, transform, reverse) {
			return String(describing: string!)
		} else {
			return source
		}
	}

	private func katakanaToHiragana(_ string: String) -> String {
		return transliterateString(source: string,
								   transform: kCFStringTransformHiraganaKatakana,
								   reverse: true)
	}

	private func katakanaToHalfKatakana(_ string: String) -> String {
		return transliterateString(source: string,
								   transform: kCFStringTransformFullwidthHalfwidth,
								   reverse: false)
	}

	public func getHiragana(roman: String) -> String {
		let str = getKatakana(roman: roman)
		return katakanaToHiragana(str)
	}

	public func getHalfKatakana(roman: String) -> String {
		let str = getKatakana(roman: roman)
		return katakanaToHalfKatakana(str)
	}

	public func getKatakana(roman: String) -> String {
		var str = roman.lowercased()
		var n: Int = 0
		while str.count >= 2 && n < str.count - 1 {
			let strL = String(str[str.startIndex ..< str.index(str.startIndex, offsetBy: n)])
			let strC = String(str[str.index(str.startIndex, offsetBy: n) ..< str.index(str.startIndex, offsetBy: n + 2)])
			let strR = String(str[str.index(str.startIndex, offsetBy: n + 2) ..< str.endIndex])
			str = strL + nCheck(strC) + strR
			n += 1
		}
		n = 0
		while str.count >= 2 && n < str.count - 1 {
			let strL = String(str[str.startIndex ..< str.index(str.startIndex, offsetBy: n)])
			let strC = String(str[str.index(str.startIndex, offsetBy: n) ..< str.index(str.startIndex, offsetBy: n + 2)])
			let strR = String(str[str.index(str.startIndex, offsetBy: n + 2) ..< str.endIndex])
			str = strL + xtuCheck(strC) + strR
			n += 1
		}
		for i in (1 ... 4).reversed() {
			n = 0
			while str.count >= i && n < str.count - (i - 1) {
				let strL = String(str[str.startIndex ..< str.index(str.startIndex, offsetBy: n)])
				let strC = String(str[str.index(str.startIndex, offsetBy: n) ..< str.index(str.startIndex, offsetBy: n + i)])
				let strR = String(str[str.index(str.startIndex, offsetBy: n + i) ..< str.endIndex])
				str = strL + convert(strC) + strR
				n += 1
			}
		}
		return str
	}

	func isRoman(_ str: Character) -> Bool {
		return NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]+").evaluate(with: String(str))
	}

	func nCheck(_ str: String) -> String {
		switch str {
		case "na": return str
		case "ni": return str
		case "nu": return str
		case "ne": return str
		case "no": return str
		case "ny": return str
		case "n'", "nn": return "ン"
		default:
			if str.first! == "n" {
				return "ン" + String(str.last!)
			} else {
				return str
			}
		}
	}

	func xtuCheck(_ str: String) -> String {
		if isRoman(str.first!) && str.first! == str.last! {
			let f = str.first!
			if f == "a" || f == "i" || f == "u" || f == "e" || f == "o" {
				return str
			} else {
				return "ッ" + String(str.last!)
			}
		}
		return str
	}

	private func convert(_ str: String) -> String {
		switch str.count {
		case 1:
			return one(str)
		case 2:
			return two(str)
		case 3:
			switch str.dropFirst().first! {
			case "y": return threeY(str)
			case "h": return threeH(str)
			case "w": return threeW(str)
			default:
				switch str {
				case "tsa": return "ツァ"
				case "tsi": return "ツィ"
				case "tsu": return "ツ"
				case "tse": return "ツェ"
				case "tso": return "ツォ"
				case "xka", "lka": return "ヵ"
				case "xke", "lke": return "ヶ"
				case "xtu", "ltu": return "ッ"
				default: break
				}
				return str
			}
		case 4:
			return (str == "xtsu" || str == "ltsu") ? "ッ" : str
		default:
			return str
		}
	}

	func one(_ str: String) -> String {
		switch str {
		case "a": return "ア"
		case "i": return "イ"
		case "u": return "ウ"
		case "e": return "エ"
		case "o": return "オ"
		default: return str
		}
	}

	func two(_ str: String) -> String {
		switch str {
		case "ba": return "バ"
		case "bi": return "ビ"
		case "bu": return "ブ"
		case "be": return "ベ"
		case "bo": return "ボ"
		case "da": return "ダ"
		case "di": return "ヂ"
		case "du": return "ヅ"
		case "de": return "デ"
		case "do": return "ド"
		case "fa": return "ファ"
		case "fi": return "フィ"
		case "fu": return "フ"
		case "fe": return "フェ"
		case "fo": return "フォ"
		case "ga": return "ガ"
		case "gi": return "ギ"
		case "gu": return "グ"
		case "ge": return "ゲ"
		case "go": return "ゴ"
		case "ha": return "ハ"
		case "hi": return "ヒ"
		case "hu": return "フ"
		case "he": return "ヘ"
		case "ho": return "ホ"
		case "ja": return "ジャ"
		case "ji": return "ジ"
		case "ju": return "ジュ"
		case "je": return "ジェ"
		case "jo": return "ジョ"
		case "ka": return "カ"
		case "ki": return "キ"
		case "ku": return "ク"
		case "ke": return "ケ"
		case "ko": return "コ"
		case "la": return "ァ"
		case "li": return "ィ"
		case "lu": return "ゥ"
		case "le": return "ェ"
		case "lo": return "ォ"
		case "ma": return "マ"
		case "mi": return "ミ"
		case "mu": return "ム"
		case "me": return "メ"
		case "mo": return "モ"
		case "na": return "ナ"
		case "ni": return "ニ"
		case "nu": return "ヌ"
		case "ne": return "ネ"
		case "no": return "ノ"
		case "pa": return "パ"
		case "pi": return "ピ"
		case "pu": return "プ"
		case "pe": return "ペ"
		case "po": return "ポ"
		case "qa": return "クァ"
		case "qi": return "クィ"
		case "qu": return "クゥ"
		case "qe": return "クェ"
		case "qo": return "クォ"
		case "ra": return "ラ"
		case "ri": return "リ"
		case "ru": return "ル"
		case "re": return "レ"
		case "ro": return "ロ"
		case "sa": return "サ"
		case "si": return "シ"
		case "su": return "ス"
		case "se": return "セ"
		case "so": return "ソ"
		case "ta": return "タ"
		case "ti": return "チ"
		case "tu": return "ツ"
		case "te": return "テ"
		case "to": return "ト"
		case "va": return "ヴァ"
		case "vi": return "ヴィ"
		case "vu": return "ヴ"
		case "ve": return "ヴェ"
		case "vo": return "ヴォ"
		case "wa": return "ワ"
		case "wi": return "ウィ"
		case "wu": return "ウ"
		case "we": return "ウェ"
		case "wo": return "ヲ"
		case "xa": return "ァ"
		case "xi": return "ィ"
		case "xu": return "ゥ"
		case "xe": return "ェ"
		case "xo": return "ォ"
		case "ya": return "ヤ"
		case "yu": return "ユ"
		case "yo": return "ヨ"
		case "za": return "ザ"
		case "zi": return "ジ"
		case "zu": return "ズ"
		case "ze": return "ゼ"
		case "zo": return "ゾ"
		default: return str
		}
	}

	func threeY(_ str: String) -> String {
		func yaiueo(head: String, str: String) -> String {
			switch str {
			case "ya": return head + "ャ"
			case "yi": return head + "ィ"
			case "yu": return head + "ュ"
			case "ye": return head + "ェ"
			case "yo": return head + "ョ"
			default: return str
			}
		}
		switch str.first! {
		case "b": return yaiueo(head: "ビ", str: String(str.dropFirst()))
		case "c": return yaiueo(head: "チ", str: String(str.dropFirst()))
		case "d": return yaiueo(head: "ヂ", str: String(str.dropFirst()))
		case "f": return yaiueo(head: "フ", str: String(str.dropFirst()))
		case "g": return yaiueo(head: "ギ", str: String(str.dropFirst()))
		case "h": return yaiueo(head: "ヒ", str: String(str.dropFirst()))
		case "j": return yaiueo(head: "ジ", str: String(str.dropFirst()))
		case "k": return yaiueo(head: "キ", str: String(str.dropFirst()))
		case "l": return yaiueo(head: "", str: String(str.dropFirst()))
		case "m": return yaiueo(head: "ミ", str: String(str.dropFirst()))
		case "n": return yaiueo(head: "ニ", str: String(str.dropFirst()))
		case "p": return yaiueo(head: "ピ", str: String(str.dropFirst()))
		case "r": return yaiueo(head: "リ", str: String(str.dropFirst()))
		case "s": return yaiueo(head: "シ", str: String(str.dropFirst()))
		case "t": return yaiueo(head: "チ", str: String(str.dropFirst()))
		case "v": return yaiueo(head: "ヴ", str: String(str.dropFirst()))
		case "x": return yaiueo(head: "", str: String(str.dropFirst()))
		case "z": return yaiueo(head: "ジ", str: String(str.dropFirst()))
		default:
			if str == "wyi" {
				return "ヰ"
			} else if str == "wye" {
				return "ヱ"
			} else {
				return str
			}
		}
	}

	func threeH(_ str: String) -> String {
		switch str {
		case "cha": return "チャ"
		case "chi": return "チ"
		case "chu": return "チュ"
		case "che": return "チェ"
		case "cho": return "チョ"
		case "dha": return "デャ"
		case "dhi": return "ディ"
		case "dhu": return "デュ"
		case "dhe": return "デェ"
		case "dho": return "デョ"
		case "sha": return "シャ"
		case "shi": return "シ"
		case "shu": return "シュ"
		case "she": return "シェ"
		case "sho": return "ショ"
		case "tha": return "テャ"
		case "thi": return "ティ"
		case "thu": return "テュ"
		case "the": return "テェ"
		case "tho": return "テョ"
		case "wha": return "ウァ"
		case "whi": return "ウィ"
		case "whu": return "ウ"
		case "whe": return "ウェ"
		case "who": return "ウォ"
		default: return str
		}
	}

	func threeW(_ str: String) -> String {
		switch str {
		case "dwa": return "ドァ"
		case "dwi": return "ドィ"
		case "dwu": return "ドゥ"
		case "dwe": return "ドェ"
		case "dwo": return "ドォ"
		case "gwa": return "グァ"
		case "gwi": return "グィ"
		case "gwu": return "グゥ"
		case "gwe": return "グェ"
		case "gwo": return "グォ"
		case "kwa": return "クァ"
		case "kwi": return "クィ"
		case "kwu": return "クゥ"
		case "kwe": return "クェ"
		case "kwo": return "クォ"
		case "lwa": return "ヮ"
		case "swa": return "スァ"
		case "swi": return "スィ"
		case "swu": return "スゥ"
		case "swe": return "スェ"
		case "swo": return "スォ"
		case "twa": return "トァ"
		case "twi": return "トィ"
		case "twu": return "トゥ"
		case "twe": return "トェ"
		case "two": return "トォ"
		case "xwa": return "ヮ"
		default: return str
		}
	}
}

