export class Book {

    private title: string;
    private author: string;
    private price: number;

    public getTitle(): string {
        return this.title;
    }

    public setValue(title: string): void {
        this.title = title;
    }

    public getAuthor(): string {
        return this.author;
    }

    public setAuthor(author: string): void {
        this.author = author;
    }
}
