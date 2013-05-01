//Look in to using enums: http://tobega.blogspot.com/2008/05/beautiful-enums.html
//http://forum.processing.org/topic/enums-in-processing-1-5-1
//reverseOrder: http://stackoverflow.com/questions/1694751/java-array-sort-descending
//sorting by two values: http://stackoverflow.com/questions/4805606/java-sort-problem-by-two-fields

static class SortArtworks implements Comparator<Artwork> {
  private String sortField;
  
  public SortArtworks(String sortField_) {
    sortField = sortField_;
  }
  
  int compare(Artwork a1, Artwork a2) {
    if (sortField == "height") {
      Integer v1 = a1.height();
      Integer v2 = a2.height();
      
      return v1.compareTo(v2);
      
    } else if (sortField == "width") {
      Integer v1 = a1.width();
      Integer v2 = a2.width();
      
      return v1.compareTo(v2);
      
    } else if (sortField == "ranking") {
      Integer v1 = a1.ranking();
      Integer v2 = a2.ranking();
      
      return v1.compareTo(v2);
      
    } else if (sortField == "classification") {
      String v1 = a1.classification();
      String v2 = a2.classification();
      
      return v1.compareTo(v2);
      
    } else if (sortField == "culture") {
      String v1 = a1.culture();
      String v2 = a2.culture();
      
      return v1.compareTo(v2);
      
    } else if (sortField == "century") {
      String v1 = a1.century();
      String v2 = a2.century();
      
      return v1.compareTo(v2);
    }
    return 0;
  }
  
  public Comparator ascending() {
     return this;
  }
  
  public Comparator descending() {
    return Collections.reverseOrder(this);
  }
}
