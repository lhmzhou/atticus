import 'package:flutter/material.dart';
 
class Bookstore {
  const Bookstore({
  @required  this.id,
  @required  this.storeName,
  @required  this.location,
  @required  this.webUrl,
  });
  final int id;
  final String storeName;
  final String location;
  final String webUrl;
}

abstract class ContentControl {
  static const List<Bookstore> Bookstores = [
    Bookstore(id: 0, storeName: "A Cultural Exchange", location: "Cleveland, Ohio", webUrl: "https://www.aculturalexchange.org"),
    Bookstore(id: 1, storeName: "Aframerican Book Store", location: "Omaha, Nebraska", webUrl: "http://aframericanbookstore.com"),
    Bookstore(id: 2, storeName: "Afriware Books, Co", location: "Maywood, Illinois", webUrl: "https://www.afriwarebooks.com"),
    Bookstore(id: 3, storeName: "Akoma Novelties & Books", location: "Evansville, Indiana", webUrl: "https://www.akomabooks.com"),
    Bookstore(id: 4, storeName: "Alkebulan Ujaama Book Store", location: "Columbus, Ohio", webUrl: ""),
    Bookstore(id: 5, storeName: "Ashay by the Bay", location: "Vallejo, California", webUrl: "https://ashaybythebay.com"),
    Bookstore(id: 6, storeName: "Best Richardson African Diaspora Literature & Culture Museum", location: "Tampa, Florida", webUrl: "https://www.bradlcmuseum.com"),
    Bookstore(id: 7, storeName: "Beyond Barcodes Bookstore", location: "Kokomo, Indiana", webUrl: ""),
    Bookstore(id: 8, storeName: "Black Dot Cultural Center", location: "Lithonia, Georgia", webUrl: "https://www.blackdotcc.com"),
    Bookstore(id: 9, storeName: "Black Pearl Books", location: "Austin, Texas", webUrl: "https://blackpearlbookstore.com"),
    Bookstore(id: 10, storeName: "Black Stone Bookstore & Cultural Center", location: "Ypsilanti, MI", webUrl: "https://www.blackstonebookstore.com"),
    Bookstore(id: 11, storeName: "Black World Books", location: "Killeen, Texas", webUrl: "https://blackworldbooks.org/"),
    Bookstore(id: 12, storeName: "Bliss Books & Wine", location: "Kansas City, Missouri", webUrl: "https://bliss-books-wine.business.site"),
    Bookstore(id: 13, storeName: "Books & Stuff", location: "Philadelphia, Pennsylvania", webUrl: "https://www.booksandstuff.info"),
    Bookstore(id: 14, storeName: "Books and Crannies", location: "Martinsville, Virginia", webUrl: "https://www.booksandcranniesva.com"),
    Bookstore(id: 15, storeName: "Brave + Kind Bookshop", location: "Decatur, Georgia", webUrl: "https://www.braveandkindbooks.com"),
    Bookstore(id: 16, storeName: "Burgundy Books", location: "Old Saybrook, Connecticut", webUrl: "https://burgundybooks.com"),
    Bookstore(id: 17, storeName: "Carol’s Books", location: "Sacramento, California", webUrl: "https://carolsbookstore.com"),
    Bookstore(id: 18, storeName: "Dare Books", location: "Longwood, Florida", webUrl: "https://darebooks.com"),
    Bookstore(id: 19, storeName: "Detroit Book City", location: "Southfield, Michigan", webUrl: "https://www.detroitbookcity.com"),
    Bookstore(id: 20, storeName: "Elizabeth’s Bookshop & Writing Centre", location: "Akron, Ohio", webUrl: ""),
    Bookstore(id: 21, storeName: "Enda’s Booktique", location: "Duncanville, Texas", webUrl: "https://endasbooktique.com"),
    Bookstore(id: 22, storeName: "Eso Won Bookstore", location: "Los Angeles, California", webUrl: "https://www.esowonbookstore.com"),
    Bookstore(id: 23, storeName: "Everyone’s Place", location: "Baltimore, Maryland", webUrl: ""),
    Bookstore(id: 24, storeName: "EyeSeeMe", location: "University City, Missouri", webUrl: "https://www.eyeseeme.com"),
    Bookstore(id: 25, storeName: "Frontline Bookstore", location: "Chicago, Illinois", webUrl: ""),
    Bookstore(id: 26, storeName: "Frugal Bookstore", location: "Boston, Massachusetts", webUrl: "https://frugalbookstore.net"),
    Bookstore(id: 27, storeName: "Harambee Books and Artworks", location: "Alexandria, Virginia", webUrl: "https://harambeebooks.org"),
    Bookstore(id: 28, storeName: "House of Consciousness", location: "Norfolk, Virginia", webUrl: "https://www.hocbookstore.com"),
    Bookstore(id: 29, storeName: "La Unique African American Books & Cultural Center", location: "Camden, NJ", webUrl: "http://www.launiquebooks.net"),
    Bookstore(id: 30, storeName: "Loyalty Bookstore", location: "Washington, D.C.", webUrl: "https://www.loyaltybookstores.com"),
    Bookstore(id: 31, storeName: "Mahogany Books", location: "West Palm Beach, Florida", webUrl: "https://www.mahoganybooks.com"),
    Bookstore(id: 32, storeName: "Marcus Books", location: "Oakland, California", webUrl: "https://tapmybio.com/marcusbook"),
    Bookstore(id: 33, storeName: "Medu Bookstore", location: "Atlanta, Georgia", webUrl: "https://www.medubookstore.com"),
    Bookstore(id: 34, storeName: "Mocha Books", location: "Tulsa, Oklahoma", webUrl: "https://www.readwithmochabooks.com"),
    Bookstore(id: 35, storeName: "Nandi’s Knowledge Cafe", location: "Highland Park, Michigan", webUrl: "http://nandisknowledgecafe.com"),
    Bookstore(id: 36, storeName: "NuBian Books", location: "Morrow, Georgia", webUrl: "https://www.houseofnubian.com"),
    Bookstore(id: 37, storeName: "Olive Tree Books N Voices", location: "Springfield, Massachusetts", webUrl: "http://olivetreebooksonline.com"),
    Bookstore(id: 38, storeName: "Positive Vibes", location: "Virginia Beach, Virginia", webUrl: "https://www.positivevibesva.com"),
    Bookstore(id: 39, storeName: "Pyramid Art Books & Custom Framing", location: "Little Rock, Arkansas", webUrl: ""),
    Bookstore(id: 40, storeName: "Semicolon Bookstore & Gallery", location: "Chicago, Illinois", webUrl: "http://www.semicolonchi.com"),
    Bookstore(id: 41, storeName: "Shades of Afrika", location: "Long Beach, California", webUrl: "https://shadesofafrika.com"),
    Bookstore(id: 42, storeName: "Source of Knowledge Book Store", location: "Newark, New Jersey", webUrl: ""),
    Bookstore(id: 43, storeName: "The Brain Lair Bookstore", location: "South Bend, Indiana", webUrl: "https://www.brainlairbooks.com"),
    Bookstore(id: 44, storeName: "The Dock Bookshop", location: "Fort Worth, Texas", webUrl: "https://www.thedockbookshop.com"),
    Bookstore(id: 45, storeName: "The Listening Tree", location: "Candler-McAfee, Georgia", webUrl: "https://listeningtreebooks.com"),
    Bookstore(id: 46, storeName: "The Lit. Bar", location: "Bronx, New York", webUrl: "http://www.thelitbar.com"),
    Bookstore(id: 48, storeName: "Cafe con Libros", location: "Brooklyn, New York", webUrl: "https://www.cafeconlibrosbk.com"),
    Bookstore(id: 49, storeName: "The Tiny Bookstore", location: "Pittsburgh, Pennsylvania", webUrl: "https://tinybookspgh.com"),
    Bookstore(id: 50, storeName: "The Underground Bookstore", location: "Chicago, Illinois", webUrl: ""),
    Bookstore(id: 51, storeName: "Turning Page Bookshop", location: "Goose Creek, South Carolina", webUrl: "https://turningpagebookshop.com"),
    Bookstore(id: 52, storeName: "Willa’s Books and Vinyl", location: "Kansas City, Missouri", webUrl: "https://www.willasbookskc.com")
  ];
}
