class Author{
  final String id;
  final String name;
  final String thumbnailUrl;
  String? description;

  Author({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    this.description,
  });
}

final List<Author> authors = [
  Author(
    id:'x606y4QWrxo',
    name:'Korn',
    thumbnailUrl:'https://drive.google.com/uc?export=view&id=15y4qTizfabCMrSqFIbm9PyM98TB8bAfE',
    description:'Banda estadounidense de nu-metal de Bakersfield, California, Estados Unidos',
  ),
  Author(
    id:'vrPk6LB9bjo',
    name:'Linkin Park',
    thumbnailUrl:'https://drive.google.com/uc?export=view&id=15l5tRBAfpCUeD0KqCDmzLIY4H7SlaBJV',
    description:'Banda estadounidense de rock alternativo procedente de Agoura Hills',
  ),
  Author(
    id:'ilX5hnH8XoI',
    name:'System of a Down',
    thumbnailUrl:'https://drive.google.com/uc?export=view&id=1r9hmZMrJAvZJkSH-Wfvx8zMNzxnUZ_yo',
    description:'banda de rock estadounidense de ascendencia armenia, formada en Glendale, California, en el año 1994',
  ),
  Author(
    id:'rJKN_880b-M',
    name:'Crazy Town',
    thumbnailUrl:'https://drive.google.com/uc?export=view&id=1n3qf7eYNxxp0C5VERAZWpxpoIgGF8OJT',
    description:' banda estadounidense de rap rock, formada en 1995 en Los Ángeles, California',
  ),
  Author(
    id:'HvLb5gdUfDE',
    name:'Blink 182',
    thumbnailUrl:'https://drive.google.com/uc?export=view&id=1nbtj3rngKeiC563z3a1ATuncYxa9jhsS',
    description:'banda estadounidense de pop punk',
  ),
  Author(
    id:'h-igXZCCrrc',
    name:'Rammstein',
    thumbnailUrl:'https://drive.google.com/uc?export=view&id=1IK3Uyd46XgBJgKY_LPyISC7RKuPSoQuz',
    description:'banda alemana de metal industrial formada en 1994',
  ),

];


class Audio {
  final String id;
  final Author author;
  final String title;
  final String duration;
  final DateTime timestamp;
  final String viewCount;

  const Audio({
    required this.id,
    required this.author,
    required this.title,
    required this.duration,
    required this.timestamp,
    required this.viewCount,
  });
}

final List<Audio> audios = [
  //first author
  Audio(
    id: 'x606y4QWrxo',
    author: authors[0],
    title: 'Rotting In Vain',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '1K',
  ),
  Audio(
    id: 'x606y4QWrxo1',
    author: authors[0],
    title: 'Alone I Break',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '7K',
  ),
  Audio(
    id: 'x606y4QWrxo2',
    author: authors[0],
    title: 'All In The Family',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '60K',
  ),
  Audio(
    id: 'x606y4QWrxo3',
    author: authors[0],
    title: 'Pop A Pill',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '7K',
  ),
  Audio(
    id: 'x606y4QWrxo4',
    author: authors[0],
    title: 'You\'ll Never Find Me',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '5K',
  ),


  //second author
  Audio(
    id: 'x606y4QWrxo5',
    author: authors[1],
    title: 'In the End',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '1K',
  ),
  Audio(
    id: 'x606y4QWrxo6',
    author: authors[1],
    title: 'Crawling',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '7K',
  ),


  //third author
  Audio(
    id: 'x606y4QWrxo7',
    author: authors[2],
    title: 'BYOB',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '1K',
  ),


  //fourth author
  Audio(
    id: 'x606y4QWrx8',
    author: authors[3],
    title: 'Butterfly',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '1K',
  ),
  Audio(
    id: 'x606y4QWrxo19',
    author: authors[3],
    title: 'Born to raise hell',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '7K',
  ),
  Audio(
    id: 'x606y4QWrxo27',
    author: authors[3],
    title: 'The Life I Chose ft. Hyro The Hero',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '60K',
  ),


  //fifth author
  Audio(
    id: 'x606y4QWrxo7e',
    author: authors[4],
    title: 'First Date',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '1K',
  ),


];