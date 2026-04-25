class EventModel {
  final String id;
  final String name;
  final String date;
  final String location;
  final String image;
  final String description;
  final double price;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.image,
    required this.description,
    required this.price,
  });

  static List<EventModel> get dummyEvents => [
        EventModel(
          id: '1',
          name: 'Sound and Light Show',
          date: 'Tonight, 8:00 PM',
          location: 'Giza Pyramids',
          image: 'https://images.unsplash.com/photo-1539650116574-8efeb43e2b50?auto=format&fit=crop&q=80&w=600',
          description: 'Experience the magic of the Pyramids of Giza illuminated at night while listening to the history of ancient Egypt.',
          price: 25.0,
        ),
        EventModel(
          id: '2',
          name: 'Cairo Jazz Festival',
          date: 'Oct 15, 6:00 PM',
          location: 'Cairo Opera House',
          image: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&q=80&w=600',
          description: 'A spectacular evening with international jazz bands performing live.',
          price: 40.0,
        ),
        EventModel(
          id: '3',
          name: 'Hot Air Balloon Ride',
          date: 'Tomorrow, 5:00 AM',
          location: 'Luxor',
          image: 'https://images.unsplash.com/photo-1563299710-1c390cb318ff?auto=format&fit=crop&q=80&w=600',
          description: 'Watch the sunrise over the Valley of the Kings from a hot air balloon.',
          price: 80.0,
        ),
        EventModel(
          id: '4',
          name: 'Nile Cruise Dinner',
          date: 'Everyday, 7:00 PM',
          location: 'Marina Cairo',
          image: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&q=80&w=600',
          description: 'Enjoy a luxurious dinner on a cruise touring the majestic Nile river with traditional performances.',
          price: 55.0,
        ),
        EventModel(
            id: '5',
            name: 'Sun Festival at Abu Simbel',
            date: 'Oct 22, 6:00 AM',
            location: 'Aswan',
            image: 'https://images.unsplash.com/photo-1572252009286-268acec5b882?auto=format&fit=crop&q=80&w=600',
            description: 'Witness the rare alignment of the sun illuminating the inner sanctuary of the Abu Simbel Temple.',
            price: 70.0
        ),
      ];
}
