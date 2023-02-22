
public class CengHashRow {

	// GUI-Based Methods
	// These methods are required by GUI to work properly.
	String hashPrefix;
	Boolean visited;
	CengBucket bucket;


	public CengHashRow(String hashPrefix, CengBucket bp)
	{
		this.visited = false;
		this.hashPrefix = hashPrefix;
		this.bucket = bp;
	}


	public String hashPrefix()
	{
		return this.hashPrefix;
	}
	
	public CengBucket getBucket()
	{
		return this.bucket;
	}

	public void Visited()
	{
		this.visited = true;
	}

	public boolean isVisited()
	{
		return this.visited;
	}
	
	// Own Methods

	public void print()
	{
		//System.out.println("\t\"row\": {");
		System.out.println("\t\t\"hashPref\": " + this.hashPrefix + ",");
		bucket.print();
		//System.out.println("\t}");
	}


}
