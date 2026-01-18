import '../models/content_item.dart';

class ContentData {
  // Emoticons data
  static final List<ContentItem> emoticons = [
    ContentItem(id: '1', content: '(˶ᵔ ᵕ ᵔ˶)', type: ContentType.emoticon, tags: ['happy', 'smile', 'cute', 'joy']),
    ContentItem(id: '2', content: '(っ＾▿＾)💨', type: ContentType.emoticon, tags: ['excited', 'happy', 'running']),
    ContentItem(id: '3', content: '(╥﹏╥)', type: ContentType.emoticon, tags: ['sad', 'cry', 'tears', 'upset']),
    ContentItem(id: '4', content: '(づ ◕‿◕ )づ', type: ContentType.emoticon, tags: ['hug', 'love', 'cute', 'happy']),
    ContentItem(id: '5', content: '(｡•́︿•̀｡)', type: ContentType.emoticon, tags: ['sad', 'disappointed', 'upset']),
    ContentItem(id: '6', content: '(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧', type: ContentType.emoticon, tags: ['magic', 'sparkle', 'excited', 'happy']),
    ContentItem(id: '7', content: '(¬‿¬)', type: ContentType.emoticon, tags: ['smirk', 'mischief', 'sly']),
    ContentItem(id: '8', content: '(⊙_⊙)', type: ContentType.emoticon, tags: ['shocked', 'surprise', 'confused']),
    ContentItem(id: '9', content: '(◕‿◕✿)', type: ContentType.emoticon, tags: ['happy', 'cute', 'flower', 'smile']),
    ContentItem(id: '10', content: '(ง •̀_•́)ง', type: ContentType.emoticon, tags: ['fight', 'determined', 'strong']),
    ContentItem(id: '11', content: '(´｡• ᵕ •｡`)', type: ContentType.emoticon, tags: ['shy', 'cute', 'blush', 'happy']),
    ContentItem(id: '12', content: '(╯°□°）╯︵ ┻━┻', type: ContentType.emoticon, tags: ['angry', 'rage', 'flip', 'table']),
    ContentItem(id: '13', content: '┬─┬ノ( º _ ºノ)', type: ContentType.emoticon, tags: ['calm', 'fix', 'table', 'sorry']),
    ContentItem(id: '14', content: '(｡♥‿♥｡)', type: ContentType.emoticon, tags: ['love', 'heart', 'happy', 'cute']),
    ContentItem(id: '15', content: '(¬_¬")', type: ContentType.emoticon, tags: ['annoyed', 'skeptical', 'doubt']),
    ContentItem(id: '16', content: '(◠‿◠✿)', type: ContentType.emoticon, tags: ['sweet', 'happy', 'cute', 'smile']),
    ContentItem(id: '17', content: '(｡•́︿•̀｡)', type: ContentType.emoticon, tags: ['sad', 'pout', 'upset']),
    ContentItem(id: '18', content: '(づ｡◕‿‿◕｡)づ', type: ContentType.emoticon, tags: ['hug', 'love', 'cuddle', 'cute']),
    ContentItem(id: '19', content: '(⌐■_■)', type: ContentType.emoticon, tags: ['cool', 'sunglasses', 'swag']),
    ContentItem(id: '20', content: '(｡･ω･｡)', type: ContentType.emoticon, tags: ['cute', 'cat', 'happy']),
    ContentItem(id: '21', content: '(☞ﾟヮﾟ)☞', type: ContentType.emoticon, tags: ['pointing', 'cool', 'hey']),
    ContentItem(id: '22', content: '☜(ﾟヮﾟ☜)', type: ContentType.emoticon, tags: ['pointing', 'cool', 'hey']),
    ContentItem(id: '23', content: '(っ˘ڡ˘ς)', type: ContentType.emoticon, tags: ['yummy', 'food', 'delicious', 'hungry']),
    ContentItem(id: '24', content: '(｡◕‿◕｡)', type: ContentType.emoticon, tags: ['happy', 'cute', 'smile', 'joy']),
    ContentItem(id: '25', content: '(ᵔᴥᵔ)', type: ContentType.emoticon, tags: ['bear', 'cute', 'happy', 'animal']),
    ContentItem(id: '26', content: '(￣︶￣)', type: ContentType.emoticon, tags: ['content', 'satisfied', 'happy']),
    ContentItem(id: '27', content: '(˘▾˘~)', type: ContentType.emoticon, tags: ['sleepy', 'tired', 'relaxed']),
    ContentItem(id: '28', content: '(╬ಠ益ಠ)', type: ContentType.emoticon, tags: ['angry', 'mad', 'rage', 'furious']),
    ContentItem(id: '29', content: '(ノಠ益ಠ)ノ彡┻━┻', type: ContentType.emoticon, tags: ['angry', 'flip', 'table', 'rage']),
    ContentItem(id: '30', content: '(◕ᴗ◕✿)', type: ContentType.emoticon, tags: ['happy', 'cute', 'flower', 'sweet']),
    ContentItem(id: '31', content: '(´• ω •`)', type: ContentType.emoticon, tags: ['cute', 'happy', 'soft', 'gentle']),
    ContentItem(id: '32', content: '(o˘◡˘o)', type: ContentType.emoticon, tags: ['happy', 'content', 'smile']),
    ContentItem(id: '33', content: '(｡･∀･)ﾉﾞ', type: ContentType.emoticon, tags: ['wave', 'hi', 'hello', 'greeting']),
    ContentItem(id: '34', content: '(づ￣ ³￣)づ', type: ContentType.emoticon, tags: ['kiss', 'love', 'hug', 'affection']),
    ContentItem(id: '35', content: '(｡･ω･｡)ﾉ♡', type: ContentType.emoticon, tags: ['love', 'wave', 'heart', 'cute']),
    ContentItem(id: '36', content: '(͡° ͜ʖ ͡°)', type: ContentType.emoticon, tags: ['lenny', 'meme', 'smirk', 'suspicious']),
    ContentItem(id: '37', content: 'ಠ_ಠ', type: ContentType.emoticon, tags: ['disapprove', 'judgement', 'look']),
    ContentItem(id: '38', content: '¯\\_(ツ)_/¯', type: ContentType.emoticon, tags: ['shrug', 'idk', 'whatever', 'dunno']),
    ContentItem(id: '39', content: '(ಥ﹏ಥ)', type: ContentType.emoticon, tags: ['cry', 'sad', 'tears', 'upset']),
    ContentItem(id: '40', content: '(´• ω •`)ﾉ', type: ContentType.emoticon, tags: ['wave', 'bye', 'hello', 'cute']),
  ];

  // GIFs data
  static final List<ContentItem> gifs = [
    ContentItem(id: 'gif1', content: 'assets/gifs/Cat Kitty GIF.gif', type: ContentType.gif, tags: ['cat', 'kitty', 'cute', 'funny']),
    ContentItem(id: 'gif2', content: 'assets/gifs/Cat Meme GIF.gif', type: ContentType.gif, tags: ['cat', 'meme', 'funny', 'comedy']),
    ContentItem(id: 'gif3', content: 'assets/gifs/Cats Cute Cat GIF.gif', type: ContentType.gif, tags: ['cat', 'cute', 'adorable', 'cats']),
    ContentItem(id: 'gif4', content: 'assets/gifs/Cute Cat GIF.gif', type: ContentType.gif, tags: ['cat', 'cute', 'sweet', 'adorable']),
    ContentItem(id: 'gif5', content: 'assets/gifs/Dance Cat GIF.gif', type: ContentType.gif, tags: ['cat', 'dance', 'party', 'fun']),
    ContentItem(id: 'gif6', content: 'assets/gifs/gif (1).gif', type: ContentType.gif, tags: ['cat', 'funny', 'cute']),
    ContentItem(id: 'gif7', content: 'assets/gifs/gif.gif', type: ContentType.gif, tags: ['cat', 'cute', 'funny']),
    ContentItem(id: 'gif8', content: 'assets/gifs/In Love Cat GIF.gif', type: ContentType.gif, tags: ['cat', 'love', 'heart', 'cute']),
    ContentItem(id: 'gif9', content: 'assets/gifs/Squinting For Real GIF.gif', type: ContentType.gif, tags: ['cat', 'squint', 'suspicious', 'funny']),
  ];

  // Memes data
  static final List<ContentItem> memes = [
    ContentItem(id: 'meme1', content: 'assets/meme/cat.png', type: ContentType.meme, tags: ['cat', 'funny', 'meme', 'cute']),
  ];

  // Get all items
  static List<ContentItem> get allItems => [...emoticons, ...gifs, ...memes];

  // Get item by ID
  static ContentItem? getItemById(String id) {
    try {
      return allItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
