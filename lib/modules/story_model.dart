
class Story {
   String url;
   String media;
   String duration;

   Story({
    required this.url,
    required this.media,
    required this.duration,
  });

   Map<String, dynamic> toMap()=> {
     "url": url,
     "media": media,
     "duration": duration,
   };
}